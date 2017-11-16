class Permission < ApplicationRecord
  has_many :entity_permissions, dependent: :destroy

  has_many :users, through: :entity_permissions, source: :entity, source_type: 'User'

  has_many :role_permissions, dependent: :destroy

  has_many :roles, through: :role_permissions

  include BuilderSupport
  builder_rmv :is_method, :source, :condition, :belongs_to_model
end
