namespace :ruby do
  task init: :environment do
    invoke :'ruby:install_bundler'
    command 'gem install rails'
  end

  task install_bundler: :environment do
     command %[gem install bundler]
  end
end
