FactoryBot.define do
  factory :user do
    name            'string'
    password_digest 'string'
    # email           'string'
    # phone_number    'string'
    # deleted_at      { DateTime.now }
  end
end

__END__

http://www.rubydoc.info/gems/factory_bot/file/GETTING_STARTED.md#Inheritance
http://www.rubydoc.info/gems/factory_bot/file/GETTING_STARTED.md#Associations
