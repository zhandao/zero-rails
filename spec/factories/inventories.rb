# FactoryBot.define do
#   factory :inventory do
#     store
#     good
#     amount 0
#   end
# end

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
