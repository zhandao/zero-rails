FactoryBot.define do
  factory :role do
    name              'role'
    condition         'true'
    # belongs_to_model  Admin
    # remarks           'string'
    # belongs_to_system 'string'
  end
end

__END__

http://www.rubydoc.info/gems/factory_bot/file/GETTING_STARTED.md#Inheritance
http://www.rubydoc.info/gems/factory_bot/file/GETTING_STARTED.md#Associations
