# frozen_string_literal: true

class User < ApplicationRecord
  active_serialize

  soft_destroy

  has_and_belongs_to_many :stored_roles, -> { where('expire_at IS NULL OR expire_at > ?', Time.current) },
                          join_table: 'users_and_user_roles', foreign_key: 'user_id',
                          class_name: 'UserRole', association_foreign_key: 'user_role_id'
  has_many_temporary_roles
  acts_as_subject

  # enum status: [ :active, :archived ]
  # enum status: { active: 0, archived: 1 }

  has_secure_password

  def jwt_payload
    {
        id: id,
        token_version: token_version
    }
  end

  def jwt_claim
    {
        exp_in: 14.days
    }
  end
end

# == Schema Information
#
# Table name: users
#
#  id              :bigint(8)        not null, primary key
#  deleted_at      :datetime
#  email           :string
#  name            :string           not null
#  password_digest :string           not null
#  phone_number    :string
#  token_version   :integer          default(0)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_users_on_email         (email) UNIQUE
#  index_users_on_name          (name) UNIQUE
#  index_users_on_phone_number  (phone_number) UNIQUE
#
