class RoleMdoc < ModelDoc
  # v 0

  has_many :entity_roles, dependent: :destroy
  has_many :admins, through: :entity_roles, source: :entity, source_type: 'Admin'
  has_many :role_permissions, dependent: :destroy
  has_many :permissions, through: :role_permissions
  self_joins :has_many

  str! :name, :not_blank
  str! :condition, default: 'true'
  str :belongs_to_model, :not_blank, default: 'Admin'
  str :remarks
  str :belongs_to_system
  attrs!

  im :add
end
