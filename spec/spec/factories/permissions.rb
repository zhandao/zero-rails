FactoryBot.define do
  factory :permission do
    name              'permission'
    condition         'true'
    # belongs_to_model  Admin
    # remarks           'string'
    # is_method         nil
    # source            'string'
    # path              'string'
    # title             'string'
    # icon              'string'
    # belongs_to_system 'string'
  end
end

__END__

http://www.rubydoc.info/gems/factory_bot/file/GETTING_STARTED.md#Inheritance
http://www.rubydoc.info/gems/factory_bot/file/GETTING_STARTED.md#Associations
