class RolePermission < ApplicationRecord
  belongs_to :role

  belongs_to :permission

  include BuilderSupport
  builder_rmv :skip_condition

  after_commit :delete_entity_cache
  def delete_entity_cache
    Rails.cache.delete_matched(/_permissions/)
  end

  def self.add(role, permission)
    create! role: role, permission: permission
  end
end
