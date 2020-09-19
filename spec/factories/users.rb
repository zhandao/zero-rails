FactoryBot.define do
  factory :user do
    name            'zhandao'
    password_digest 'zhandao'
    # email           'string'
    # phone_number    'string'
    # deleted_at      { DateTime.now }
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
