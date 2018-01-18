class GoodMdoc < ModelDoc
  # v 0
  dsc
  soft_destroy

  belongs_to :category
  has_many :inventories, dependent: :destroy
  has_many :inv_operations
  has_many :records
  has_many :book_records
  has_many :floors, through: :inventories

  str! :name, :not_blank
  str! :unit, :not_blank
  str! :creator, :not_blank
  flt! :price, :not_blank, num: { gte: 0.0 }
  str  :part_number
  str  :brand
  str  :specifications
  str  :remarks
  str  :pic_path
  bool :need_approve, default: false
  bool :need_return, default: false
  bool :is_online, default: true
  attrs!

  sc :all_view
  sc :online_view
  sc :offline_view
  sc :get_view
  sc :borrow_view
  sc :created_between
  sc :search_by_category
  sc :search_by
  sc :ordered

  after_create :create_inventory_records

  im :change_online
end
