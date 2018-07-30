# class PermissionMdoc < ModelDoc
#   # v 0
#
#   has_many :entity_permissions, dependent: :destroy
#   has_many :users, through: :entity_permissions, source: :entity, source_type: 'User'
#
#   has_many :role_permissions, dependent: :destroy
#   has_many :roles, through: :role_permissions
#   self_joins :has_many
#
#   str! :name, :not_blank
#   str  :source # 权限对应的资源，如 Floor
#   str  :model
#   str  :remarks
#   attrs!
# end
