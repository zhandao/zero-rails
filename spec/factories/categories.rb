FactoryBot.define do
  factory :category do
    name             'sub_cate'
    base_category_id 1
    # deleted_at       { DateTime.now }
  end

  factory :base_category, class: Category do
    name             'base'
    base_category_id nil
  end
end

__END__

http://www.rubydoc.info/gems/factory_bot/file/GETTING_STARTED.md#Inheritance
http://www.rubydoc.info/gems/factory_bot/file/GETTING_STARTED.md#Associations
