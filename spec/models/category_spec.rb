require 'rails_helper'
require 'dssl/model'

RSpec.describe Category, type: :model do
  let(:category) { create(:category) }
  subject { category }

  acts_as_paranoid

  before { create(:base_category) } # base is created before subject, so it's id is 1.
  let(:base_category) { Category.find_by(name: 'base') }

  desc '.extend_search_by_name', "[scope] `extend` means that: when search a base_cate, should return all of it's sub_cates." do
    it { expect(subject.base_category).to eq base_category } # TODO: `to be` shows that the two base_cate obj is not the same one.

    it { called by: 'sub', get: [category.id] }

    context 'when pass a base category name' do
      it('also returns all ids of the sub categories') { called by: 'base', get: [base_category.id, category.id] }
    end
  end

  desc '.from_base_categories', '[scope]' do
    it { called get: [base_category] }
  end

  desc :path, '@return [ base_cate_name, sub_cate_name ]' do
    it { called get: ['base', 'sub_cate'] }
  end

  # describe '#json_addition, show the base cate when not getting nested list' do
  # end
end
