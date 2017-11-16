module ZeroPermission

  # TODO: private
  def self.included(base)
    # # TODO: 这里应该可选择性配置：如果不需要 AOP check，那么应该在第一次调 can? 和 in_the_group? 时调用配置
    # base.after_initialize :roles_setting
    # base.after_initialize :permissions_setting
    # base.after_initialize :enable_check_permission_before_calling_method
  end

  def current_permissions
    @_current_permissions ||= { }
  end

  def methods_under_permission_check
    @_methods_under_permission_check ||= [ ]
  end

  # TODO: 高消耗操作?
  # TODO:父子形式输出
  def all_permissions
    permissions_setting
    current_permissions.keys.map do |key|
      # TODO: 带有 block 的判断是无法在这里进行的，所以不返回
      next if key.match? /_block/
      can?(key) ? key : nil rescue nil
    end.compact
  end

  def role *roles, options, &block
    if options.key? :can_call
      can_call options.fetch(:can_call), options[:model], options.merge!(role: roles), &block
    else
      roles = roles.first if roles.first.is_a?(Array)
      can options.fetch(:can), options[:model], options.merge!(role: roles), &block
    end
  end

  def role_group group, options, &block
    roles_groups[group].each do |role|
      self.role role, options, &block
    end
  end

  def can actions, source = nil, options, &block
    [options[:role]].flatten.each do |_role|
      Array(actions).each do |action|
        key = source ? "#{action}_#{source.name.downcase}" : action
        # TODO: 怎么延迟做 when
        current_permissions[key] ||= is?(_role) && (options[:when].nil? || options[:when])
        # TODO: block 不要放到 c_p
        (current_permissions["#{key}_block"] ||= [ ]) << block if block_given?
      end
    end
  end

  def add_permission *actions
    self.permissions << Permission.where(name: actions)
  end

  def can_call methods, source = nil, options, &block
    methods_under_permission_check.concat Array(methods)
    can methods, source, options, &block
  end

  def if_case
    { when: true }
  end

  def can? action, source = nil
    return true if action.nil?
    permissions_setting # TODO: 优化

    _source = source.is_a?(Module) ? source : source.class if source
    key = _source ? "#{action}_#{_source.name.downcase}".to_sym : action
    current_permissions[key] && permission_blocks_result(source, key) || false
  end
  alias has_permission? can?

  def permission_blocks_result(source, key)
    blocks = current_permissions["#{key}_block"]
    return true if blocks.nil?
    blocks.each do |block|
      return true if instance_exec(source, &block)
    end
    false
  end

  def can! action, source = nil
    raise InsufficientPermission unless can? action, source
  end
  alias has_permission! can!

  def can_all_of? *actions
    actions.each { |action| return false unless can? action }
    true
  end

  def can_all_of! *actions
    actions.each { |action| can! action }
  end

  # TODO: 支持对 source model 的方法调用进行切面处理
  # TODO: 支持对控制器方法进行切面处理
  def enable_check_permission_before_calling_method
    # Ruby AOP easy way: https://stackoverflow.com/a/24559474
    self.class.prepend Checker.with(methods_under_permission_check.uniq)
  end

  module Checker
    def self.with(methods)
      methods.each do |method|
        define_method method do |*args|
          can! method
          super(*args)
        end
      end

      self
    end
  end

  # TODO: 支持 group 和 family 的持久化
  # TODO: cache key configure
  # TODO: 父子权限：如果父权限无效，则子孙无效，逻辑同 role family
  def load_permissions_from_database
    roles_setting # TODO: 优化（这句还是必要的，如果不是所有都走数据库）
    Rails.cache.fetch("#{self.class.name.underscore}_#{self.id}_permissions") do
      assoc_roles = roles.includes(:role_permissions, :permissions).to_a
      role_permissions = assoc_roles.map(&:role_permissions).flatten.uniq
      base_role_permissions = assoc_roles.map(&:base_role).compact.map(&:role_permissions).flatten.uniq # TODO: 优化
      entity_permissions = EntityPermission.where(permission_id: self.permissions.pluck(:id))
      relations = [ *role_permissions, *base_role_permissions, *entity_permissions ]

      relations.map do |relation|
        pmi = permission = relation.permission
        options = { when: relation.skip_condition || instance_eval(pmi.condition || 'true') }
        [ (pmi.is_method ? :can_call : :can), pmi.name.to_sym, pmi.source, options ]
      end
    end.each { |args| send *args }
  end

  def permissions_setting
    @_current_permissions, @_methods_under_permission_check = { }, [ ]
    load_permissions_from_database
  end

  class InsufficientPermission < StandardError; end
end
