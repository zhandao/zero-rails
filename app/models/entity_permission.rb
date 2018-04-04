class EntityPermission < ApplicationRecord
  belongs_to :entity, polymorphic: true

  belongs_to :permission

  before_create  :check_model

  def check_model
    if permission.model.present?
      throw :abort unless entity_type.in?(permission.model.split)
    end
  end

  after_commit :delete_entity_cache
  def delete_entity_cache
    Rails.cache.delete "#{entity_type.underscore}_#{entity_id}_permissions"
  end

  def self.add(entity, permission)
    create! entity: entity, permission: permission
  end
end
