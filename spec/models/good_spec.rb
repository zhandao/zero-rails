require 'rails_helper'
require 'dssl/model'

RSpec.describe Good, type: :model do
  let(:category) { create(:category) }
  let(:good) { create(:good) }
  subject { good }

  acts_as_paranoid

  before { good }

  desc '.default_scope', 'defaults to join relation' do
    it { expect { Good.where('categories.id = 1') }.not_to raise_error }
  end

  desc '.all_view', '[scope]' do
    it { called has_size: :all }
  end

  desc '.online_view', '[scope]' do
    before { create(:good, on_sale: false) }
    it { called all_attrs: { on_sale: true } }
  end

  desc '.offline_view', '[scope]' do
    before { create(:good, on_sale: false) }
    it { called all_attrs: { on_sale: false } }
  end

  desc '.created_between', '[scope]' do
    it { called by: [nil, nil], get: :all }
  end

  desc '.search_by_category', '[scope]' do
    it { called by: 'sub', get: [good] }
  end

  desc '.search_by', '[scope]' do
    it { called by: [nil, nil], get: [good] }
    it { called by: ['name', nil], get: [good] }
    it { called by: [nil, 'name'], get: [good] }
    it { called by: ['name', 'oo'], get: [good] }
    it { called by: ['name', 'ooo'], get: [] }
  end

  desc '.ordered', '[scope]' do
    before { create(:good, name: 'older', created_at: Date.yesterday) }
    before { create(:good, name: 'newer', created_at: Date.tomorrow) }
    it { called get: [Good.find_by(name: 'newer'), good, Good.find_by(name: 'older')] }
  end

  desc :change_onsale, focus_on: :on_sale do
    it do
      called get: true
      expect_it.to be_falsey
      called get: true
      expect_it.to be_truthy
    end
  end
end
