class Inventory < ApplicationRecord
  belongs_to :store

  belongs_to :good

  builder_support add: 'good_info and store_info'

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

__END__

t.belongs_to :store,  foreign_key: true, null: false
t.belongs_to :good,   foreign_key: true, null: false
t.integer    :amount, null: false, default: 0

add_index :inventories, [:store_id, :good_id], unique: true
