class CreateRolePermissions < ActiveRecord::Migration::Current
  def change
    create_table :role_permissions, force: :cascade do |t|
      t.belongs_to :role,       foreign_key: true
      t.belongs_to :permission, foreign_key: true

      t.timestamps
    end

    add_index :role_permissions, [:role_id, :permission_id], unique: true, using: :btree
  end
end
