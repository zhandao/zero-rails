class Good < ApplicationRecord
  extend Search

  has_many :inventories, dependent: :destroy

  has_many :stores, -> { where('amount > 0') }, through: :inventories

  belongs_to :category

  builder_support rmv: %i[ ], add: %i[ unscoped: category_info ]

  soft_destroy

  default_scope { includes :category }
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

  after_create do
    Inventory.create!(Store.all.map { |store| { store: store, good: self } })
  end

  def change_onsale
    update! on_sale: !on_sale
  end
end
