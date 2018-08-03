class CreateRoles < ActiveRecord::Migration::Current
  def change
    create_table :roles, force: :cascade do |t|
      t.string     :name,      null: false
      t.string     :model,     null: false, default: 'User'
      t.string     :remarks
      t.references :base_role, index: true

      t.timestamps
    end

    add_index :roles, [:name, :model], unique: true, name: 'role_unique_index', using: :btree
  end
end
