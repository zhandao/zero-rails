# require 'rails_helper'
# require 'dssl/model'
#
# RSpec.describe Admin, type: :model do
#   let(:admin) { create(:admin) }
#   subject { admin }
#
#   acts_as_paranoid
#
#   desc :name do
#     it { called get: 'a.b' }
#   end
#
#   desc :logout, focus_on: :token_version do
#     it 'will inc 1' do
#       expect_it.to eq default = 1
#       called get: true
#       expect_it.to eq default + 1
#     end
#   end
#
#   desc :add, focus_on: :roles do
#     context 'role' do
#       it 'will add a role to the admin' do
#         expect_it.to eq [ ]
#         role = create(:role)
#         called by: { role: role.name }, get: [role]
#       end
#     end
#   end
# end
