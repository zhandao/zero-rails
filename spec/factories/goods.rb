FactoryBot.define do
  factory :good do
    category   { Category.last || association(:category) }
    name       'good'
    unit       'string'
    price      1.0
    # remarks    'string'
    # picture    'string'
    # on_sale    true
    # deleted_at { DateTime.now }
  end
end

__END__

http://www.rubydoc.info/gems/factory_bot/file/GETTING_STARTED.md#Inheritance
http://www.rubydoc.info/gems/factory_bot/file/GETTING_STARTED.md#Associations
