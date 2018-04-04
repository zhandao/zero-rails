require 'rails_helper'
require 'dssl/model'

RSpec.describe Store, type: :model do
  let(:store) { create(:store) }
  subject { store }

  acts_as_paranoid

  describe '#create_inventory_records, [after_create]' do
    it do
      create(:good)
      store
      expect(Inventory.count).not_to eq 0
    end
  end
end
