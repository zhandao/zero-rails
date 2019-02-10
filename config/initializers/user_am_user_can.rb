IAmICan::Configs.set_for(subject: 'User',
                         role: 'UserRole',
                         permission: 'UserPermission') do |config|

    config.without_group = true

end
