class Good < ApplicationRecord
  has_many :inventories, dependent: :destroy

  has_many :stores, through: :inventories

  belongs_to :category

  acts_as_paranoid

  include BuilderSupport
  builder_rmv :deleted_at
  builder_add :unscoped, :category_info

  default_scope { includes :category }
  scope :all_view, -> { all }
  scope :online_view, -> { where is_online: true }
  scope :offline_view, -> { where is_online: false }

  scope :created_between, ->(start_at, end_at) do
    where created_at: start_at||0..end_at||Float::INFINITY unless start_at.nil? && end_at.nil?
  end

  scope :search_by_category, ->(category_name) do
    category_ids = Category.extend_search_by_name(category_name)
    where 'categories.id': category_ids
  end

  scope :search_by, ->(field, value) do
    return if field.nil? || value.nil?
    if field == 'category_name'
      search_by_category name = value
    else
      # has no SQL injection risk
      where "#{field} LIKE ?", "%#{value}%"
    end
  end

  scope :ordered, -> { order created_at: :desc }

  scope :get, ->(association) { includes(association).map(&association.to_sym).flatten.compact }

  after_create do
    Inventory.create!(Store.all_from_cache.map { |store| { store: store, good: self } })
  end

  def change_online
    self.is_online = !is_online
    save
  end
end
