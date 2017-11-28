class Store < ApplicationRecord
  has_many :inventories, dependent: :destroy

  has_many :goods, through: :inventories

  acts_as_paranoid

  builder_support rmv: %i[ deleted_at ]

  after_commit do
    Rails.cache.delete_matched(/stores/)
  end

  after_create do
    Inventory.create!(Good.all { |good| { store: self, good: good } })
  end

  def self.all_from_cache
    Rails.cache.fetch('stores') { all.to_a }
  end
end
