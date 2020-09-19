FactoryBot.define do
  factory :category do
    name             'sub_cate'
    base_category_id 1
    # deleted_at       { DateTime.now }
  end

  factory :base_category, class: Category do
    name             'base'
    base_category_id nil
  end
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
