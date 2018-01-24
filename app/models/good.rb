class Good < ApplicationRecord
  include Search

  default_scope { includes :category }

  has_many :inventories, dependent: :destroy

  has_many :stores, -> { where('amount > 0') }, through: :inventories

  belongs_to :category, -> { unscope(where: :deleted_at) }

  builder_support rmv: %i[ ], add: [:category_info]

  soft_destroy

  validates *%i[ name unit ], presence: true

  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0.0 }

  scope :on_sale, -> { where on_sale: true }
  scope :off_sale, -> { where on_sale: false }

  scope :created_between, ->(start_at, end_at) do
    where created_at: start_at||0..end_at||Float::INFINITY unless start_at.nil? && end_at.nil?
  end

  scope :search_category_name, ->(category_name) do
    category_ids = Category.extend_search_by_name(category_name)
    where 'categories.id': category_ids
  end

  scope :ordered, -> { order created_at: :desc }

  after_create :create_inventory_records

  def create_inventory_records
    Inventory.create!(Store.all.map { |floor| { store: floor, good: self } })
  end

  def change_onsale
    update! on_sale: !on_sale
  end
end

__END__

t.string     :name,       null: false,       index: true
t.belongs_to :category,   foreign_key: true, index: true
t.string     :unit,       null: false
t.float      :price,      null: false
t.string     :remarks
t.string     :picture
t.boolean    :on_sale,                       default: true
t.datetime   :deleted_at
