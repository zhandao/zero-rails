class EntityRole < ApplicationRecord
  belongs_to :entity, polymorphic: true

  belongs_to :role

  include BuilderSupport
  builder_rmv :skip_condition

  before_create  :check_belongs
  def check_belongs
    throw :abort unless entity_type == role.belongs_to_model
  end

  after_commit :delete_entity_cache
  def delete_entity_cache
    # CHECK FIXME
    Rails.cache.delete "#{entity_type.underscore}_#{entity_id}_roles"
    Rails.cache.delete "#{entity_type.underscore}_#{entity_id}_permissions"
  end

  def add(entity, role)
    create entity: entity, role: role
  end
end
