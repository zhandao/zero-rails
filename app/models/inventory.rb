# frozen_string_literal: true

class Inventory < ApplicationRecord
  belongs_to :store

  belongs_to :good

  active_serialize recursive: %i[ good store ]

  validates :amount, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  def increase(much)
    return if much <= 0
    self.amount += much
    save # returns boolean
  end

  def decrease(much)
    return if much <= 0
    self.amount -= much
    return false if amount < 0
    save
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
