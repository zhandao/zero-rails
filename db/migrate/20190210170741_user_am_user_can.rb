class UserAmUserCan < ActiveRecord::Migration::Current
  def change
    create_table :user_roles, force: :cascade do |t|
      t.string  :name,    null: false
      t.string  :remarks

      t.timestamps
    end

    add_index :user_roles, :name, unique: true, name: 'user_roles_unique_index'

    # === end of role table ===

    create_table :user_permissions, force: :cascade do |t|
      t.string  :action,   null: false
      t.string  :obj_type
      t.integer :obj_id
      t.string  :remarks

      t.timestamps
    end

    add_index :user_permissions, %i[ action obj_type obj_id ], unique: true, name: 'user_permissions_unique_index'
    ### Open below if you want to use `Resource.that_allow` frequently
    # add_index :user_permissions, %i[ action obj_type ], name: 'user_permissions_resource_search_index'

    # === end of permission table ===

    create_table :users_and_user_roles, id: false, force: :cascade do |t|
      t.belongs_to :user, null: false#, index: false
      t.belongs_to :user_role, null: false#, index: false
      t.datetime   :expire_at
    end

    # add_index :users_and_user_roles, :user_id, name: ':users_and_user_roles_index1'
    # add_index :users_and_user_roles, :user_role_id, name: ':users_and_user_roles_index2'
    add_index :users_and_user_roles, [ :user_id, :user_role_id, :expire_at ],
              unique: true, name: 'users_and_user_roles_uniq_index'

    # === end of subject-role table ===

    create_table :user_roles_and_user_permissions, id: false, force: :cascade do |t|
      t.belongs_to :user_role, null: false#, index: false
      t.belongs_to :user_permission, null: false#, index: false
    end

    # add_index :user_roles_and_user_permissions, :user_role_id, name: 'user_roles_and_user_permissions_index1'
    # add_index :user_roles_and_user_permissions, :user_permission_id, name: 'user_roles_and_user_permissions_index2'
    add_index :user_roles_and_user_permissions, [ :user_role_id, :user_permission_id ],
              unique: true, name: 'user_roles_and_user_permissions_uniq_index'

    # === end of role-permission table ===

  end
end
