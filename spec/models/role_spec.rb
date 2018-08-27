require 'rails_helper'
require 'dssl/model'

RSpec.describe Role, type: :model do
  let(:role) { create(:role) }
  subject { role }

  func :add, focus_on: :permissions do
    context 'permission' do
      it 'will add a permission to the role' do
        expect_it.to eq [ ]
        permission = create(:permission)
        calls by: { permission: permission.name }, get: [permission]
      end
    end
  end
end
