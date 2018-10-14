# class RoleMdoc < ModelDoc
#   # v 0
#
#   has_many :entity_roles, dependent: :destroy
#   has_many :users, through: :entity_roles, source: :entity, source_type: 'User'
#
#   has_many :role_permissions, dependent: :destroy
#   has_many :permissions, through: :role_permissions
#   self_joins :has_many
#
#   str! :name, :not_blank
#   str :model, format: /\A[A-Z][A-z]*\z/
#   str :remarks
#   attrs!
#
#   im :add
# end
