class Category < ApplicationRecord
  has_many   :sub_categories, class_name: 'Category', foreign_key: 'base_category_id'
  belongs_to :base_category,  class_name: 'Category', optional: true

  has_many :goods#, dependent: :nullify

  acts_as_paranoid

  builder_support rmv: %i[ updated_at created_at delete_at ]
  # builder_add :base_category, when: proc { is_smaller }
  builder_add :sub_categories_info, when: :get_nested_list

  def self.all_from_cache
    Rails.cache.fetch('categories') { all.to_a }
  end

  scope :search_by_name, ->(name) { where 'name LIKE ?', "%#{name}%" }

  # `extend` means that: when search a base_cate, should return all of it's sub_cates.
  # @retrun ids array
  scope :extend_search_by_name, -> (name) do
    Rails.cache.fetch("extend_categories_#{name}") do
      searched = search_by_name(name)
      (searched.ids + searched.map { |cate| cate.sub_categories.ids }).flatten.uniq
    end
  end

  scope :from_base_categories, -> { where base_category: nil }

  after_commit do
    Rails.cache.delete_matched(/categories/)
  end

  # @return [ base_cate_name, sub_cate_name ]
  def path
    base_category.nil? ? [ name, '' ] : [ Category.all_from_cache[base_category_id - 1].name, name ]
  end

  # show the base cate when not getting nested list
  def json_addition
    proc do |json|
      # TODO HACK
      if base_category.present? && !Category.instance_variable_get('@get_nested_list')
        json.base_category Category.all_from_cache[base_category_id - 1].to_builder
      end
    end
  end
end
