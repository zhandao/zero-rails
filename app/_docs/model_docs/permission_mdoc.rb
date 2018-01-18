class PermissionMdoc < ModelDoc
  # v 0

  has_many :entity_permissions, dependent: :destroy
  has_many :admins, through: :entity_permissions, source: :entity, source_type: 'Admin'
  has_many :role_permissions, dependent: :destroy
  has_many :roles, through: :role_permissions
  self_joins :has_many

  str! :name, :not_blank
  str! :condition, default: 'true'
  str :belongs_to_model, :not_blank, default: 'Admin'
  str :remarks
  bool :is_method # TODO: remove, 考虑到对实例的某个方法增加切面验证权限并非常见（一般都是对控制器动作给切面）
  str :source # 权限对应的资源，如 Floor
  str :path # TODO: 像 path icon 这些信息明显不是通用 Permission 模型属性，可行的重构手段是扔给多态关联的一个新 Model
  str :title # TODO: remove
  str :icon
  str :belongs_to_system # TODO: remove
  attrs!

  sc :all_view
  sc :page_view
  sc :floor_view
  sc :from_base_permissions
end
