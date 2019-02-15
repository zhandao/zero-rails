# frozen_string_literal: true

class Store < ApplicationRecord
  has_many :inventories, dependent: :destroy

  has_many :goods, -> { where('amount > 0') }, through: :inventories

  active_serialize rmv: %i[ ]

  soft_destroy

  validates *%i[ name address ], presence: true

  after_create :create_inventory_records

  def create_inventory_records
    Inventory.create!(Good.all.map { |good| { store: self, good: good } })
  end
end

# == Schema Information
#
# Table name: stores
#
#  id         :bigint(8)        not null, primary key
#  address    :string           not null
#  deleted_at :datetime
#  name       :string           not null
#
# Indexes
#
#  index_stores_on_address  (address) UNIQUE
#  index_stores_on_name     (name) UNIQUE
#
