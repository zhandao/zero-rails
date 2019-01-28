class CreateEntityPermissions < ActiveRecord::Migration::Current
  def change
    create_table :entity_permissions, force: :cascade do |t|
      t.belongs_to :entity,     polymorphic: true
      t.belongs_to :permission, foreign_key: true

      t.timestamps
    end

    add_index :entity_permissions, [:entity_id, :entity_type, :permission_id],
              unique: true, name: 'entity_permission_unique_index', using: :btree
  end
end
