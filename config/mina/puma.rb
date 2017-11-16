namespace :puma do
  task init: :environment do
    invoke :'puma:update_config'
  end

  task update_config: :environment do
    content = erb('config/puma.rb.erb')
     command %(echo 'update puma config file')
     command %(echo '#{content}' > #{ fetch(:shared_path)}/config/puma.rb)
  end
end
