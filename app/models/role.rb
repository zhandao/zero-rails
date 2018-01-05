class Role < ApplicationRecord
  has_many :entity_roles, dependent: :destroy

  has_many :users, through: :entity_roles, source: :entity, source_type: 'User'

  has_many :role_permissions, dependent: :destroy

  has_many :permissions, through: :role_permissions

  has_many   :sub_roles, class_name: 'Role', foreign_key: 'base_role_id'
  belongs_to :base_role, class_name: 'Role', optional: true

  builder_support rmv: %i[ condition belongs_to_model ]

  def add_permission(permission)
    permissions << Permission.find_by(name: permission)
  end
end
