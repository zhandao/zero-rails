class Store < ApplicationRecord
  acts_as_paranoid

  has_many :inventories, dependent: :destroy

  has_many :goods, through: :inventories

  builder_support rmv: %i[ deleted_at ]

  validates *%i[ code addr ], presence: true

  after_create :create_inventory_records

  def create_inventory_records
    Inventory.create!(Good.all.map { |good| { floor: self, good: good } })
  end
end

__END__

t.string   :code,       null: false
t.string   :addr,       null: false
t.datetime :deleted_at
