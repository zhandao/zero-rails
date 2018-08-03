class CreatePermissions < ActiveRecord::Migration::Current
  def change
    create_table :permissions, force: :cascade do |t|
      t.string     :name,   null: false
      t.belongs_to :source, polymorphic: true
      t.string     :model,  null: false, default: 'User'
      t.string     :remarks

      t.timestamps
    end

    add_index :permissions, [:name, :source_type, :source_id, :model], unique: true,
              name: 'permission_unique_index', using: :btree
  end
end
