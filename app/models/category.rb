class Category < ApplicationRecord
  has_many   :sub_categories, class_name: 'Category', foreign_key: 'base_category_id'
  belongs_to :base_category,  class_name: 'Category', optional: true

  has_many :goods#, dependent: :nullify

  builder_support rmv: %i[ updated_at created_at ]
  builder_add :sub_categories_info, when: :get_nested_list

  soft_destroy

  validates :name, presence: true

  scope :search_by_name, ->(name) { where 'name LIKE ?', "%#{name}%" }

  # `extend` means that: when search a base_cate, should return all of it's sub_cates.
  # @retrun ids array
  scope :extend_search_by_name, -> (name) do
    Rails.cache.fetch("extend_categories_#{name}", expires_in: 1.day) do
      searched = search_by_name(name)
      (searched.ids + searched.map { |c| c.sub_categories.ids }).flatten.uniq
    end
  end

  scope :from_base_categories, -> { where base_category: nil }

  after_commit :clear_cache

  def clear_cache
    Rails.cache.delete_matched(/categories/)
  end

  # @return [ base_cate_name, sub_cate_name ]
  def path
    base_category.nil? ? [ name, '' ] : [ Category.all[base_category_id - 1].name, name ]
  end

  # show the base cate when not getting nested list
  def json_addition
    proc do |json|
      # TODO HACK
      if base_category.present? && !Category.instance_variable_get('@get_nested_list')
        json.base_category Category.find(base_category_id).to_builder
      end
    end
  end
end


__END__

t.string     :name,          null: false
t.integer    :base_category
t.datetime   :deleted_at
