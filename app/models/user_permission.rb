class UserPermission < ActiveRecord::Base
  has_and_belongs_to_many :related_roles,
                          join_table: 'user_roles_and_user_permissions', foreign_key: :user_permission_id,
                          class_name: 'UserRole', association_foreign_key: :user_role_id

  belongs_to :resource, polymorphic: true

  acts_as_permission
end

__END__

  string  :action,     null: false
  string  :obj_type
  integer :obj_id
  string  :desc

  index %i[ action obj_type obj_id ], unique: true
