# frozen_string_literal: true

require 'open_api/generator'

module MakeSure
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    # 使控制业务逻辑的权限码能够被可以统一集中地修改映射权限名
    def permission_map map_hash
      MakeSure.permission_mapper.merge! map_hash
    end

    def if_can *permission_codes, source: nil, allow: [ ], allow_matched: [ ]
      allow = ::OpenApi::Generator.get_actions_by_route_base(controller_path) if allow == :all
      if allow.present?
        to_access *allow, should_can: permission_codes, source: source
      else
        to_access_matched *allow_matched, should_can: permission_codes, source: source
      end
    end

    def if_is logic_codes, allow: [ ], allow_matched: [ ]
      allow = ::OpenApi::Generator.get_actions_by_route_base(controller_path) if allow == :all
      if allow.present?
        to_access *allow, need_to_be: logic_codes
      else
        to_access_matched *allow_matched, need_to_be: logic_codes
      end
    end

    def to_access *actions, need_to_be: nil, should_can: nil, source: nil
      actions += %i[ index show create update destroy ] if actions.delete(:CRUDI)
      # prepend ?
      before_action only: actions do
        # user_token_verify! if make_sure.nil?
        make_sure.can!(should_can, source: source) if should_can
        make_sure :it, is: need_to_be if need_to_be
      end
    end

    def to_access_matched *actions, need_to_be: nil, should_can: nil, source: nil
      ctrl_actions = ::OpenApi::Generator.get_actions_by_route_base(controller_path)
      real_actions = [ ]
      actions.each { |pattern| real_actions += ctrl_actions.grep(/#{pattern}/) }
      to_access *real_actions, need_to_be: need_to_be, should_can: should_can, source: source
    end

    # Logic can't be equivalent to Service Object
    def logic name, lambda = nil, success: true, fail: false, &block
      # TODO: 控制器划分
      MakeSure.logics[name] = { block: block, lambda: lambda, success: success, fail: fail }
    end
  end

  # ---- Instance Methods ----

  def subject obj
    @_make_sure_obj = obj
  end

  def it action = nil, *args, &block
    make_sure :it, action, *args, &block
  end

  class NoPass < Object; end
  # make_sure obj, :can, :permission1, :permission2
  #
  # subject current_user
  # make_sure :it, must: :not_null
  # it must: %i[ not_alone be_happy ]
  # TODO: make_sure(a and b)
  # TODO: make_sure :it, :can, read: book
  def make_sure(obj = NoPass, action = nil, *args, &block)
    @_make_sure_obj = obj if obj == :it
    @_make_sure_obj = current_user if obj == NoPass
    return self if action.nil?

    if action.is_a?(Symbol)
      return send(action, *args, &block)
    elsif action.is_a?(Hash)
      result = true
      action.each do |action_name, arg|
        action_name = :must if action_name.in?(%i[ must_be must_be! is is? ])
        result &= send(action_name, arg)
      end
      return result
    end

    self
  end

  # make_sure(obj).can :permission { }
  # make_sure(obj).can :permission, :then { }
  # make_sure(obj).can :permission, :else { }
  def can? *permission_codes, source: nil, &block
    block_condition = permission_codes.delete(:then) || permission_codes.delete(:else)
    permission_codes.flatten.each do |code|
      vp = vactual_permissions = [ *Array(MakeSure.permission_mapper[code] || code) ]
      # vp = [ *vp, *PermissionCode.where(code: code).map(&:permissions).flatten.compact.map(&:name).uniq ]
      unless @_make_sure_obj.can_all_of? *vp, source: source
        instance_eval(&block) if block_condition == :else
        return false
      end
    end

    instance_eval(&block) if block_given?
    true
  end

  alias_method :can, :can?

  def can! *permission_codes, source: nil
    raise IAmICan::Permission::InsufficientPermission unless can? *permission_codes, source: source
  end

  def must *logic_names
    success = nil
    logic_names.each do |logic_name|
      logic = MakeSure.logics.fetch(logic_name)
      result = logic[:lambda] ? @_make_sure_obj.instance_exec(&logic[:lambda]) : instance_eval(&logic[:block])

      if result
        success ||= logic[:success] # Returns the success of the final judgment
      elsif logic[:fail].is_a?(Symbol)
        Error::Api.send("#{logic[:fail]}!")
      else
        return logic[:fail] || false
      end
    end

    success
  end

  alias must! must


  cattr_accessor :logics do
    { }
  end

  cattr_accessor :role_mapper do
    { }
  end

  cattr_accessor :permission_mapper do
    { }
  end
end


__END__

permission_map manage_role_permission: nil, manage_user: nil

def can_manage_role_permission!
  make_sure current_user, :can!, :manage_role_permission
end

def can_manage_user!
  make_sure current_user, :can!, :manage_user
  make_sure(current_user).can! :manage_user
  make_sure.can! :manage_user
  can! :manage_user
end

to_access :interface, need_to_be: :huge_man
to_access :interface, should_can: :do_anything # scenario: focus on actions
if_can :do_anything, allow: :interface         # scenario: focus on Strategy
if_can :read, source: Good, allow: :show
