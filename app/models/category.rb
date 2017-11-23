class Category < ApplicationRecord
  has_many   :sub_categories, class_name: 'Category', foreign_key: 'base_category_id'
  belongs_to :base_category,  class_name: 'Category', optional: true

  has_many :goods#, dependent: :nullify

  acts_as_paranoid

  include BuilderSupport
  builder_rmv :updated_at, :created_at, :delete_at
  # builder_add :base_category, when: proc { is_smaller }
  builder_add :sub_categories_info, when: :get_nested_list

  # TODO: clear caches admin op
  def self.all_from_cache
    Rails.cache.fetch('categories') { all.to_a }
  end

  scope :search_by_name, ->(name) { where 'name LIKE ?', "%#{name}%" }

  scope :extend_search_by_name, ->(name) do
    Rails.cache.fetch("extend_categories_#{name}") do
      search_result = search_by_name(name).pluck(:id)
      search_result.map do |id|
        all_from_cache[id - 1].sub_categories&.map(&:id)
      end.concat(search_result).flatten.uniq
    end
  end

  scope :from_base_categories, -> { where base_category: nil }

  # TODO: all scope and aft_cmt => concern
  after_commit do
    Rails.cache.delete_matched(/categories/)
  end

  def path
    base_category.nil? ? [ name, '' ] : [ Category.all_from_cache[base_category_id - 1].name, name ]
  end

  def json_addition
    proc do |json|
      # TODO HACK
      if base_category.present? && !Category.instance_variable_get('@get_nested_list')
        json.base_category Category.all_from_cache[base_category_id - 1].to_builder
      end
    end
  end
end
