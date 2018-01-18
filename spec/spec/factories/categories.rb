FactoryBot.define do
  factory :category do
    name         'sub_cate'
    is_smaller   true
    bigger_id    1
    # icon_name    'string'
    # deleted_at   { DateTime.now }
  end

  factory :base_category, class: Category do
    name      'base'
    is_smaller false
    bigger_id  0
  end
end

__END__

http://www.rubydoc.info/gems/factory_bot/file/GETTING_STARTED.md#Inheritance
http://www.rubydoc.info/gems/factory_bot/file/GETTING_STARTED.md#Associations
