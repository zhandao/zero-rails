class GoodMdoc < ModelDoc
  # v 0
  dsc
  soft_destroy

  belongs_to :category
  has_many :inventories, dependent: :destroy
  has_many :stores, through: :inventories

  str! :name, :not_blank
  str! :unit, :not_blank
  flt! :price, :not_blank, num: { gte: 0.0 }
  str  :picture
  str  :remarks
  bool :on_sale, default: true
  attrs!

  sc :on_sale
  sc :off_sale
  sc :created_between
  sc :search_category_name
  sc :search
  sc :ordered

  after_create :create_inventory_records

  im :change_onsale
end
