require 'rails_helper'
require 'dssl/model'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }
  subject { user }

  acts_as_paranoid

  # desc :logout, focus_on: :token_version do
  #   it 'will inc 1' do
  #     expect_it.to eq default = 1
  #     called get: true
  #     expect_it.to eq default + 1
  #   end
  # end

  desc :add, focus_on: :roles do
    context 'role' do
      it 'will add a role to the user' do
        expect_it.to eq [ ]
        role = create(:role)
        called by: { role: role.name }, get: [role]
      end
    end
  end
end
