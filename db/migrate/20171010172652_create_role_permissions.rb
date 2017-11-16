class CreateRolePermissions < ActiveRecord::Migration[5.1]
  def change
    create_table :role_permissions, options: 'ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8' do |t|
      t.belongs_to :role,           foreign_key: true
      t.belongs_to :permission,     foreign_key: true
      t.boolean    :skip_condition, default: true

      t.timestamps
    end

    add_index :role_permissions, [:role_id, :permission_id], unique: true
  end
end
