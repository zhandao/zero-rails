class Inventory < ApplicationRecord
  belongs_to :store

  belongs_to :good

  builder_support add: %i[ unscoped: good_info store_info ]

  def increase(much)
    self.amount += much
    save # returns boolean
  end

  def decrease(much)
    self.amount -= much
    return false if amount.negative?
    save
  end
end
