class Category < ApplicationRecord
  include Search

  has_many   :sub_categories, class_name: 'Category', foreign_key: 'base_category_id'
  belongs_to :base_category,  class_name: 'Category', optional: true

  has_many :goods#, dependent: :nullify

  builder_support rmv: %i[ updated_at created_at ]
  builder_add :sub_categories_info, when: :get_nested_list
  builder_add :base_category_info, name: :base_category, when: -> { base_category.present? } # TODO: 思考：为什么 get_nested_list 时不会有该 info？

  soft_destroy

  validates :name, presence: true

  # `extend` means that: when search a base_cate, should return all of it's sub_cates.
  # @retrun ids array
  scope :extend_search_by_name, -> (name) do
    searched = search('name', with: name)
    (searched.ids + searched.map { |c| c.sub_categories.ids }).flatten.uniq
  end

  scope :from_base_categories, -> { where base_category: nil }

  # @return [ base_cate_name, sub_cate_name ]
  def path
    base_category.nil? ? [ name, '' ] : [ base_category&.name, name ]
  end
end


__END__

t.string   :name,          null: false
t.integer  :base_category
t.datetime :deleted_at
