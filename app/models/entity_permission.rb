class EntityPermission < ApplicationRecord
  belongs_to :entity, polymorphic: true

  belongs_to :permission

  before_create  :check_belongs
  def check_belongs
    throw :abort unless entity_type == permission.belongs_to_model
  end

  after_commit :delete_entity_cache
  def delete_entity_cache
    Rails.cache.delete "#{entity_type.underscore}_#{entity_id}_permissions"
  end

  def add(entity, permission)
    create entity: entity, permission: permission
  end
end
