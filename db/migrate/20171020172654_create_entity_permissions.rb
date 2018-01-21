class CreateEntityPermissions < ActiveRecord::Migration[5.1]
  def change
    create_table :entity_permissions, options: 'ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8' do |t|
      t.belongs_to :entity,     polymorphic: true
      t.belongs_to :permission, foreign_key: true

      t.timestamps
    end

    add_index :entity_permissions, [:entity_id, :entity_type, :permission_id],
              unique: true, name: 'entity_permission_unique_index'
  end
end
