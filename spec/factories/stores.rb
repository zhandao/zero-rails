FactoryBot.define do
  factory :store do
    name       'store'
    address    'some where'
    # deleted_at { DateTime.now }
  end
end

__END__

http://www.rubydoc.info/gems/factory_bot/file/GETTING_STARTED.md#Inheritance
http://www.rubydoc.info/gems/factory_bot/file/GETTING_STARTED.md#Associations
