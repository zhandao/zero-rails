class CategoryMdoc < ModelDoc
  # v 0
  soft_destroy

  self_joins :has_many
  has_many :goods

  str! :name, :not_blank
  attrs!

  sc :search_by_name
  sc :extend_search_by_name, "`extend` means that: when search a base_cate, should return all of it's sub_cates."
  sc :from_base_categories

  after_commit :clear_cache

  im :path, '@return [ base_cate_name, sub_cate_name ]'
  im :json_addition, 'show the base cate when not getting nested list'
end
