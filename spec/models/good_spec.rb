require 'rails_helper'
require 'dssl/model'

RSpec.describe Good, type: :model do
  let(:category) { create(:category) }
  let(:good) { create(:good) }
  subject { good }

  acts_as_paranoid

  before { good }

  func '.default_scope', 'defaults to join relation' do
    it { expect { Good.where('categories.id = 1') }.not_to raise_error }
  end

  func '.on_sale', '[scope]' do
    before { create(:good, on_sale: false) }
    it { called all_attrs: { on_sale: true } }
  end

  func '.off_sale', '[scope]' do
    before { create(:good, on_sale: false) }
    it { called all_attrs: { on_sale: false } }
  end

  func '.created_between', '[scope]' do
    it { called by: [nil, nil], get: :all }
  end

  func '.search_category_name', '[scope]' do
    it { called by: 'sub', get: [good] }
  end

  func '.search', '[scope]' do
    it { called by: [nil, with: nil], get: [good] }
    it { called by: ['name', with: nil], get: [good] }
    it { called by: [nil, with: 'name'], get: [good] }
    it { called by: ['name', with: 'oo'], get: [good] }
    it { called by: ['name', with: 'ooo'], get: [] }
    # TODO: cover all fields
  end

  func '.ordered', '[scope]' do
    before { create(:good, name: 'older', created_at: Date.yesterday) }
    before { create(:good, name: 'newer', created_at: Date.tomorrow) }
    it { called get: [Good.find_by(name: 'newer'), good, Good.find_by(name: 'older')] }
  end

  func :change_onsale, focus_on: :on_sale do
    it do
      called get: true
      expect_it.to be_falsey
      called get: true
      expect_it.to be_truthy
    end
  end
end
