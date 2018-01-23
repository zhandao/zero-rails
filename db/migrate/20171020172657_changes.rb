class Changes < ActiveRecord::Migration[5.1]
  def change
    Role.where(model: nil).update_all(model: '')
    Permission.where(model: nil).update_all(model: '')
    change_column :roles, :model, :string, default: '', null: false
    change_column :permissions, :model, :string, default: '', null: false
    add_index :roles, [:name, :model], unique: true, name: 'role_unique_index'
    add_index :permissions, [:name, :source, :model], unique: true, name: 'permission_unique_index'
  end
end
