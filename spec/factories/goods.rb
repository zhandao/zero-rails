FactoryBot.define do
  factory :good do
    category   { Category.last || association(:category) }
    name       'good'
    unit       'string'
    price      1.0
    # remarks    'string'
    # picture    'string'
    # on_sale    true
    # deleted_at { DateTime.now }
  end
end

# == Schema Information
#
# Table name: goods
#
#  id          :bigint(8)        not null, primary key
#  deleted_at  :datetime
#  name        :string           not null
#  on_sale     :boolean          default(TRUE)
#  picture     :string
#  price       :float            not null
#  remarks     :string
#  unit        :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  category_id :bigint(8)
#
# Indexes
#
#  index_goods_on_category_id  (category_id)
#  index_goods_on_name         (name)
#
# Foreign Keys
#
#  fk_rails_...  (category_id => categories.id)
#
