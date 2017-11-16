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
  end

  private

  # make_sure obj, :can, :permission
  # TODO: 可以延伸 action 为策略，但如果过重，还是抽成服务好一些
  def make_sure(obj, action = nil, *permission_codes)
    @_make_sure_obj = obj
    return self if action.nil?

    if action.match /can/
      action = :can? if action == :can
      send(action, *permission_codes)
    end
  end

  def can? *permission_codes, &block
    permission_codes.each do |code|
      vp = vactual_permissions = [ ]
      vp = [ *vp, *Array(self.class.permission_mapper&.[](code)) ]
      # vp = [ *vp, *PermissionCode.where(code: code).map(&:permissions).flatten.compact.uniq.map(&:name) ]
      return false unless @_make_sure_obj.can_all_of? *vp
    end

    instance_eval &block if block_given?
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
