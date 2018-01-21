class CreateEntityRoles < ActiveRecord::Migration[5.1]
  def change
    create_table :entity_roles, options: 'ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8' do |t|
      t.belongs_to :entity, polymorphic: true
      t.belongs_to :role,   foreign_key: true

      t.timestamps
    end

    add_index :entity_roles, [:entity_id, :entity_type, :role_id],
              unique: true, name: 'entity_roles_unique_index'
  end
end
