require 'rails_helper'
require 'dssl/model'

RSpec.describe Inventory, type: :model do
  before { create(:store) }
  let(:good) { create(:good) }
  let(:inventory) { good.inventories.first } # has many thought
  subject { inventory }

  func :increase, focus_on: :amount do
    it do
      calls by: 3, get: true
      expect_it.to eq 3
      calls by: 7, get: true
      expect_it.to eq 10
    end

    it 'rejects negative number' do
      calls by: -1, get: nil
    end
  end

  func :decrease, focus_on: :amount do
    context 'when amount was not enough' do
      it('will not save') { calls by: 1, get: false }
    end

    it do
      inventory.increase(10)
      calls by: 3, get: true
      expect_it.to eq 7
      calls by: 7, get: true
      expect_it.to eq 0
    end

    it 'rejects negative number' do
      calls by: -1, get: nil
    end
  end
end

# == Schema Information
#
# Table name: inventories
#
#  id         :bigint(8)        not null, primary key
#  amount     :integer          default(0), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  good_id    :bigint(8)
#  store_id   :bigint(8)
#
# Indexes
#
#  index_inventories_on_good_id               (good_id)
#  index_inventories_on_store_id              (store_id)
#  index_inventories_on_store_id_and_good_id  (store_id,good_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (good_id => goods.id)
#  fk_rails_...  (store_id => stores.id)
#
