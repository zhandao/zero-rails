class UserRole < ActiveRecord::Base
  has_and_belongs_to_many :related_users,
                          join_table: 'users_and_user_roles', foreign_key: :user_role_id,
                          class_name: 'User', association_foreign_key: :user_id

  has_and_belongs_to_many :permissions,
                          join_table: 'user_roles_and_user_permissions', foreign_key: :user_role_id,
                          class_name: 'UserPermission', association_foreign_key: :user_permission_id

  acts_as_role

  # default_scope { with_permissions }
end

__END__

  string  :name, null: false
  string  :desc

  index :name, unique: true
