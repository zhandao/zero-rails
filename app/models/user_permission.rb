# frozen_string_literal: true

class UserPermission < ActiveRecord::Base
  has_and_belongs_to_many :related_roles,
                          join_table: 'user_roles_and_user_permissions', foreign_key: :user_permission_id,
                          class_name: 'UserRole', association_foreign_key: :user_role_id

  belongs_to :resource, polymorphic: true

  acts_as_permission
end

# == Schema Information
#
# Table name: user_permissions
#
#  id         :bigint(8)        not null, primary key
#  action     :string           not null
#  obj_type   :string
#  remarks    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  obj_id     :integer
#
# Indexes
#
#  user_permissions_unique_index  (action,obj_type,obj_id) UNIQUE
#
