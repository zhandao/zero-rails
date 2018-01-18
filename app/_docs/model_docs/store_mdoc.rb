class StoreMdoc < ModelDoc
  # v 0
  soft_destroy

  has_many :inventories, dependent: :destroy
  has_many :inv_operations
  has_many :records
  has_many :book_records
  has_many :goods, through: :inventories

  str! :code, :not_blank
  str! :addr, :not_blank
  attrs!

  after_create :create_inventory_records
end
