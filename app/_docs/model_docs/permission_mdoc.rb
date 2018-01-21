class PermissionMdoc < ModelDoc
  # v 0

  has_many :entity_permissions, dependent: :destroy
  has_many :users, through: :entity_permissions, source: :entity, source_type: 'Admin'

  has_many :role_permissions, dependent: :destroy
  has_many :roles, through: :role_permissions
  self_joins :has_many

  str! :name, :not_blank
  str :source # 权限对应的资源，如 Floor
  str :model
  str :remarks
  attrs!

  sc :all_view
  sc :page_view
  sc :floor_view
  sc :from_base_permissions
end
