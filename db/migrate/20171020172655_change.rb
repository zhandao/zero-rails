class Change < ActiveRecord::Migration[5.1]
  def change
    remove_column :categories, :icon_name
    remove_column :goods, :creator
    remove_column :roles, :condition
    remove_column :permissions, :condition
    remove_column :permissions, :for_method
    remove_column :entity_roles, :skip_condition
    remove_column :entity_permissions, :skip_condition
    remove_column :role_permissions, :skip_condition
    rename_column :goods, :pic_path, :picture
    rename_column :stores, :code, :name
    rename_column :stores, :addr, :address

    remove_column :roles, :belongs_to_model
    add_column :roles, :model, :string
    remove_index :roles, name: :index_roles_on_name_and_belongs_to_model

    remove_column :permissions, :belongs_to_model
    add_column :permissions, :model, :string
    remove_index :permissions, name: :index_permissions_on_name_and_belongs_to_model
  end
end
