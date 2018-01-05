class RolePermission < ApplicationRecord
  belongs_to :role

  belongs_to :permission

  builder_support rmv: %i[ skip_condition ]

  after_commit :delete_entity_cache
  def delete_entity_cache
    Rails.cache.delete_matched(/_permissions/)
  end

  def self.add(role, permission)
    create! role: Role.find_by(name: role), permission: Permission.find_by(name: permission)
  end
end
