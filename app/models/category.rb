# frozen_string_literal: true

class Category < ApplicationRecord
  include Search

  has_many   :sub_categories, class_name: 'Category', foreign_key: 'base_category_id'
  belongs_to :base_category,  class_name: 'Category', optional: true

  include ToTree
  as_tree by_key: 'base_category_id'

  has_many :goods#, dependent: :nullify

  active_serialize rmv: %i[ updated_at created_at ]
  # builder_add :sub_categories_info, when: :get_nested_list TODO !!!
  # builder_add :base_category_info, name: :base_category, when: -> { base_category.present? } # TODO: 思考：为什么 get_nested_list 时不会有该 info？

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

# == Schema Information
#
# Table name: categories
#
#  id               :bigint(8)        not null, primary key
#  deleted_at       :datetime
#  name             :string           not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  base_category_id :bigint(8)
#
# Indexes
#
#  index_categories_on_base_category_id  (base_category_id)
#  index_categories_on_name              (name) UNIQUE
#
