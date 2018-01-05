class Good < ApplicationRecord
  has_many :inventories, dependent: :destroy

  has_many :stores, through: :inventories

  belongs_to :category

  acts_as_paranoid

  builder_support rmv: %i[ deleted_at ], add: %i[ unscoped: category_info ]

  default_scope { includes :category }
  scope :all_view, -> { all }
  scope :online_view, -> { where on_sale: true }
  scope :offline_view, -> { where on_sale: false }

  scope :created_between, ->(start_at, end_at) do
    where created_at: start_at||0..end_at||Float::INFINITY unless start_at.nil? && end_at.nil?
  end

  scope :search_by_category, ->(category_name) do
    category_ids = Category.extend_search_by_name(category_name)
    where 'categories.id': category_ids
  end

  scope :search_by, -> (field, value) do
    return if field.nil? || value.nil?
    case field
    when 'category_name' then search_by_category(name = value)
    when 'price'         then where(price: value)
    else where("goods.#{field} LIKE ?", "%#{value}%") # Note: 这里不会有注入风险，在参数检查的时候已经校验其输入在合法范围内了
    end
  end

  scope :ordered, -> { order created_at: :desc }

  after_create do
    Inventory.create!(Store.all_from_cache.map { |store| { store: store, good: self } })
  end

  def change_onsale
    update! is_online: !is_online
  end
end
