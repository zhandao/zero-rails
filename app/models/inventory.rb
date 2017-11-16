class Inventory < ApplicationRecord
  belongs_to :store

  belongs_to :good

  include BuilderSupport
  builder_add :unscoped, :good_info, :floor_info

  def increase(much)
    self.amount += much
    save # returns boolean
  end

  def decrease(much)
    self.amount -= much
    return false if amount < 0
    save
  end
end
