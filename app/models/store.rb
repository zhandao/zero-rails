class Store < ApplicationRecord
  has_many :inventories, dependent: :destroy

  has_many :goods, -> { where('amount > 0') }, through: :inventories

  builder_support rmv: %i[ ]

  soft_destroy

  validates *%i[ name address ], presence: true

  after_create :create_inventory_records

  def create_inventory_records
    Inventory.create!(Good.all.map { |good| { store: self, good: good } })
  end
end

__END__

t.string   :code,       null: false
t.string   :addr,       null: false
t.datetime :deleted_at
