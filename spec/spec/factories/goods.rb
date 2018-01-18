FactoryBot.define do
  factory :good do
    category       { Category.last || association(:category) }
    name           'good'
    unit           'string'
    creator        'string'
    price          1.0
    # part_number    'string'
    # brand          'string'
    # specifications 'string'
    # remarks        'string'
    # pic_path       'string'
    # need_approve   false
    # need_return    false
    # is_online      true
    # deleted_at     { DateTime.now }
  end
end

__END__

http://www.rubydoc.info/gems/factory_bot/file/GETTING_STARTED.md#Inheritance
http://www.rubydoc.info/gems/factory_bot/file/GETTING_STARTED.md#Associations
