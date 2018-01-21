require 'rails_helper'
require 'dssl/model'

RSpec.describe Inventory, type: :model do
  before { create(:store) }
  let(:good) { create(:good) }
  let(:inventory) { good.inventories.first } # has many thought
  subject { inventory }

  desc :increase, focus_on: :amount do
    it do
      called by: 3, get: true
      expect_it.to eq 3
      called by: 7, get: true
      expect_it.to eq 10
    end

    it 'rejects negative number' do
      called by: -1, get: nil
    end
  end

  desc :decrease, focus_on: :amount do
    context 'when amount is not enough' do
      it('will not save') { called by: 1, get: false }
    end

    it do
      inventory.increase(10)
      called by: 3, get: true
      expect_it.to eq 7
      called by: 7, get: true
      expect_it.to eq 0
    end

    it 'rejects negative number' do
      called by: -1, get: nil
    end
  end
end
