require 'rails_helper'
require 'dssl/model'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }
  subject { user }

  acts_as_paranoid

  # func :logout, focus_on: :token_version do
  #   it 'will inc 1' do
  #     expect_it.to eq default = 1
  #     calls get: true
  #     expect_it.to eq default + 1
  #   end
  # end

  func :add, focus_on: :roles do
    context 'role' do
      it 'will add a role to the user' do
        expect_it.to eq [ ]
        role = create(:role)
        calls by: { role: role.name }, get: [role]
      end
    end
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
