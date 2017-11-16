source 'https://gems.ruby-china.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

ruby '2.4.1'

# TODO: 分组

# gem 'zero-rails_openapi'
# gem 'zero-params_processor'
# gem 'zero-rails_openapi', github: 'zhandao/zero-rails_openapi'
# gem 'zero-params_processor', github: 'zhandao/zero-params_processor'
gem 'zero-rails_openapi', path: '~/ws/zero-rails_openapi'
gem 'zero-params_processor', path: '~/ws/zero-params_processor'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.1.2'
# Use mysql as the database for Active Record
gem 'mysql2', '>= 0.3.18', '< 0.5'
# Use postgresql as the database for Active Record
# gem 'pg', '~> 0.18'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# https://github.com/redis-store/redis-rails
# gem 'redis-rails'

# Use Puma as the app server
gem 'puma', '~> 3.7'

# https://github.com/intridea/multi_json/
gem 'multi_json'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# https://devblast.com/b/jbuilder
gem 'jbuilder'
# https://github.com/rails-api/active_model_serializers/
# gem 'active_model_serializers'

# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'
# ruby-JWT, https://github.com/jwt/ruby-jwt
gem 'jwt'

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem 'rack-cors'

# Easiest way to add multi-environment yaml settings to Rails
# https://github.com/railsconfig/config
gem 'config'

# https://github.com/elabs/pundit/
## gem "pundit"
# https://github.com/CanCanCommunity/cancancan
## gem 'cancancan', '~> 2.0'

# Office Open XML Spreadsheet Generation, https://github.com/randym/axlsx
# gem 'axlsx'
# gem 'axlsx_rails'

# An attempt to tame Rails' default policy to log everything.
# https://github.com/roidrage/lograge
gem 'lograge'
# https://github.com/shadabahmed/logstasher/
gem 'logstasher'
# https://github.com/dwbutler/logstash-logger/
# gem 'logstash-logger'

# 管理后台
# https://activeadmin.info/documentation.html
gem 'activeadmin', '1.0'#, github: 'activeadmin' TODO: wait for fixing 1.1
# https://github.com/cle61/arctic_admin
gem 'arctic_admin'
# https://github.com/vigetlabs/active_material
# gem "active_material", github: "vigetlabs/active_material"
# ^ ActiveAdmin UI ^
# https://github.com/sferik/rails_admin
# gem 'rails_admin', '~> 1.2'
# https://github.com/igorkasyanchuk/rails_db
# Rails Database Viewer and SQL Query Runner
# gem 'rails_db', group: :development

# 分页, https://github.com/kaminari/kaminari
gem 'kaminari'
# By_* Lets you find ActiveRecord + Mongoid objects by year, month, fortnight, week and more!
# https://github.com/radar/by_star
# gem 'by_star', git: "git://github.com/radar/by_star"

# 定时任务处理, https://github.com/javan/whenever
gem 'whenever', require: false

# 请求频率限制, https://github.com/kickstarter/rack-attack
gem 'rack-attack'

# 异常邮件通知, https://github.com/smartinez87/exception_notification
# gem 'exception_notification'

# Classier solution for file uploads for Rails
# https://github.com/carrierwaveuploader/carrierwave
# gem 'carrierwave'

# https://github.com/heroku/rack-timeout
gem 'rack-timeout'

# https://github.com/mperham/sidekiq
# gem 'sidekiq'

# https://github.com/zhandao/sms
# gem 'smart_sms', path: '~/ws/sms'
# gem 'smart_sms', github: 'zhandao/sms'

# 项目的配置管理
# https://github.com/huacnlee/rails-settings-cached
# gem "rails-settings-cached"

# https://github.com/hooopo/second_level_cache/
# gem 'second_level_cache', '~> 2.3.0'

# https://github.com/norman/friendly_id
# gem 'friendly_id', '~> 5.1.0'

# Soft Delete, https://github.com/rubysherpas/paranoia
# gem "paranoia", github: "rubysherpas/paranoia", branch: "rails5" # will bundle install error
gem "paranoia", "~> 2.2"

# https://github.com/ClosureTree/closure_tree
# Easily and efficiently make your ActiveRecord models support hierarchies
# gem 'closure_tree'
# https://github.com/amerine/acts_as_tree
# gem 'acts_as_tree', '~> 2.7'

# 抽象
# https://github.com/AaronLasseigne/active_interaction
# Manage application specific business logic.
# gem 'active_interaction', '~> 3.5'
#
# https://github.com/collectiveidea/interactor
# Interactor provides a common interface for performing complex user interactions.
# gem "interactor", "~> 3.0"
# https://github.com/adomokos/light-service
# Series of Actions with an emphasis on simplicity.
# gem 'light-service'
# https://github.com/dry-rb/dry-transaction, Business transaction DSL
# gem 'dry-transaction'
# https://github.com/cypriss/mutations
# Compose your business logic into commands that sanitize and validate input.
# gem 'mutations'
#
# https://github.com/krisleech/wisper
# A micro library providing Ruby objects with Publish-Subscribe capabilities
# gem 'wisper', '2.0.0'

# https://github.com/rails/arel
# Rails integrates it by default
# https://github.com/activerecord-hackery/ransack, Object-based searching.
# gem 'ransack', github: 'activerecord-hackery/ransack'

group :development do
  # http://nadarei.co/mina/
  gem 'mina', require: false
  gem 'mina-puma', require: false
  # Plugin for Mina that adds support for multiple stages.
  # https://github.com/endoze/mina-multistage
  gem 'mina-multistage', require: false
  # gem 'mina-sidekiq', require: false

  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

  # https://github.com/yuki24/did_you_mean
  gem 'did_you_mean'

  gem 'better_errors'
  gem 'binding_of_caller'

  ### Security and Code Quality tools
  # an open source static analysis tool which checks Ruby on Rails applications for security vulnerabilities.
  # https://github.com/presidentbeef/brakeman
  gem 'brakeman', :require => false

  # The raising security scanner for ruby web applications
  # https://github.com/thesp0nge/dawnscanner
  # gem 'dawnscanner', :require=>false

  # https://github.com/bbatsov/rubocop
  gem 'rubocop', require: false
  # https://github.com/toshimaru/rubocop-rails
  # gem "rubocop-rails", require: false
end

# console beautifying settings
# https://github.com/ascendbruce/awesome_rails_console
gem 'awesome_rails_console'
# Please clean up duplicated gems if any.
# Feel free to remove gems that you don't want to use or if they conflict with other gem dependencies. (you might need to update .pryrc also)
group :development, :test do
  # -- awesome_rails_console
  gem 'hirb'
  gem 'hirb-unicode'
  gem 'pry'
  gem 'pry-byebug'
  gem 'pry-stack_explorer'
  # -- awesome_rails_console

  # https://github.com/rspec/rspec-rails
  # http://www.betterspecs.org/
  # https://relishapp.com/rspec/rspec-core/v/3-7
  # https://relishapp.com/rspec/rspec-rails/v/3-7
  # https://ruby-china.org/topics/9271
  # https://github.com/rspec/rspec-expectations
  gem 'rspec-rails' # TODO
  # http://www.rubydoc.info/gems/factory_bot/file/GETTING_STARTED.md
  gem 'factory_bot_rails'

  # TODO
  # gem 'rspec-sidekiq'
  # gem 'faker'
  # gem 'capybara'
  # https://github.com/DatabaseCleaner/database_cleaner/
  gem 'database_cleaner'
  # gem 'selenium-webdriver'
  # gem 'shoulda-matchers'
end

group :test do
  # Code coverage for Ruby 1.9+ with a powerful configuration library and automatic merging of coverage across test suites
  # https://github.com/colszowka/simplecov
  # gem 'simplecov', :require => false

  # gem 'rspec-sidekiq'
end

group :production, :staging do
  # https://github.com/newrelic/rpm
  # https://newrelic.com
  gem 'newrelic_rpm'
end