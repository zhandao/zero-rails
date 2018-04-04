class EntityRole < ApplicationRecord
  belongs_to :entity, polymorphic: true

  belongs_to :role

  builder_support rmv: %i[ ]

  before_create  :check_model

  def check_model
    if role.model.present?
      throw :abort unless entity_type.in?(role.model.split)
    end
  end

  after_commit :delete_entity_cache

  def delete_entity_cache
    # CHECK FIXME
    Rails.cache.delete "#{entity_type.underscore}_#{entity_id}_roles"
    Rails.cache.delete "#{entity_type.underscore}_#{entity_id}_permissions"
  end

  def self.add(entity, role)
    create! entity: entity, role: role
  end
end
