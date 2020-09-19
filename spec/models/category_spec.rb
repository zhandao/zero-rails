require 'rails_helper'
require 'dssl/model'

RSpec.describe Category, type: :model do
  let(:category) { create(:category) }
  subject { category }

  acts_as_paranoid

  before { create(:base_category) } # base is created before subject, so it's id is 1.
  let(:base_category) { Category.find_by(name: 'base') }

  func '.extend_search_by_name', "[scope] `extend` means that: when search a base_cate, should return all of it's sub_cates." do
    it { expect(subject.base_category).to eq base_category } # TODO: `to be` shows that the two base_cate obj is not the same one.

    it { calls by: 'sub', get: [category.id] }

    context 'when passed a base category name' do
      it('also returns all ids of the sub categories') { calls by: 'base', get: [base_category.id, category.id] }
    end
  end

  func '.from_base_categories', '[scope]' do
    it { calls get: [base_category] }
  end

  func :path, '@return [ base_cate_name, sub_cate_name ]' do
    it { calls get: ['base', 'sub_cate'] }
  end

  # describe '#json_addition, show the base cate when not getting nested list' do
  # end
end

# == Schema Information
#
# Table name: categories
#
#  id               :bigint(8)        not null, primary key
#  deleted_at       :datetime
#  name             :string           not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  base_category_id :bigint(8)
#
# Indexes
#
#  index_categories_on_base_category_id  (base_category_id)
#  index_categories_on_name              (name) UNIQUE
#
