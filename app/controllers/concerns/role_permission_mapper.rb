require 'open_api/generator'

module RolePermissionMapper
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    attr_accessor :role_mapper, :permission_mapper

    # 使控制业务逻辑的权限码能够被可以统一集中地修改映射权限名
    def permission_map map_hash
      (self.permission_mapper ||= { }).merge! map_hash
    end

    def to_access *actions, need_to_be: nil, should_can: nil
      actions += %i[ index show create update destroy ] if actions.delete(:CRUDI)
      before_action only: actions do
        make_sure.can!(should_can)
      end
    end

    def to_access_matched *actions, need_to_be: nil, should_can: nil
      ctrl_actions = ::OpenApi::Generator.get_actions_by_ctrl_path(controller_path)
      real_actions = [ ]
      actions.each { |pattern| real_actions += ctrl_actions.grep(/#{pattern}/) }
      to_access *real_actions, need_to_be, should_can
    end

    def if_can *permission_codes, allow: [ ], allow_matched: [ ]
      if allow.present?
        to_access *allow, should_can: permission_codes
      else
        to_access_matched *allow_matched, should_can: permission_codes
      end
    end
  end

  # make_sure obj, :can, :permission
  # TODO: 可以延伸 action 为策略，但如果过重，还是抽成服务好一些
  def make_sure(obj = nil, action = nil, *permission_codes)
    @_make_sure_obj = obj || current_user
    return self if action.nil?

    if action.match?(/can/)
      action = :can? if action == :can
      send(action, *permission_codes)
    elsif action.match?(/is/)
      #
    else
      #
    end

    self
  end

  def can? *permission_codes, &block
    permission_codes.each do |code|
      vp = vactual_permissions = [ *Array(self.class.permission_mapper&.[](code) || code) ]
      # vp = [ *vp, *PermissionCode.where(code: code).map(&:permissions).flatten.compact.map(&:name).uniq ]
      return false unless @_make_sure_obj.can_all_of? *vp
    end

    instance_eval(&block) if block_given?
    true
  end

  # make_sure(obj).can? :permission, and_then do .. end
  def and_then
    { }
  end

  def can! *permission_codes
    raise ZeroPermission::InsufficientPermission unless can? *permission_codes
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
