namespace :ruby do
  task init: :environment do
    invoke :'ruby:install_bundler'
  end

  task install_bundler: :environment do
     command %[gem install bundler]
  end
end
