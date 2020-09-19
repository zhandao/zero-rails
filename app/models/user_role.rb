# frozen_string_literal: true

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

# == Schema Information
#
# Table name: user_roles
#
#  id         :bigint(8)        not null, primary key
#  name       :string           not null
#  remarks    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  user_roles_unique_index  (name) UNIQUE
#
