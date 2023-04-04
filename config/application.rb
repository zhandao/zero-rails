require_relative "boot"

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_mailbox/engine"
require "action_text/engine"
require "action_view/railtie"
require "action_cable/engine"
require "sprockets/railtie"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

Dir[Pathname.new(File.dirname(__FILE__)).realpath.parent.join('lib', 'monkey_patches', '*.rb')].each { require _1 }

module ZeroRails
  $app_name = name.underscore

  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    config.eager_load_paths << "#{Rails.root}/app/_docs"
    config.eager_load_paths << "#{Rails.root}/app/_docs/others" if Rails.env.development?

    config.eager_load_paths << Rails.root.join('lib')

    # config.cache_store = :redis_store, Keys.redis.cache_url, { expires_in: 30.days, multithread: true }
    config.cache_store = :redis_store, Keys.redis.cache_url, { expires_in: 1.day }

    config.encoding = 'utf-8'

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true

    # for ActiveAdmin
    config.middleware.use ActionDispatch::Flash
    config.middleware.use Rack::MethodOverride

    config.middleware.use Rack::Attack

    config.time_zone = 'Beijing'
    # config.active_record.default_timezone = :local

    config.active_job.queue_adapter = :sidekiq
  end
end
