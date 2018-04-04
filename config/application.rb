require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

Dir[Pathname.new(File.dirname(__FILE__)).realpath.parent.join('lib', 'monkey_patches', '*.rb')].map do |file|
  require file
end

module RailsApi
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.

    config.before_configuration do
      env_file = File.join(Rails.root, 'config', 'local_env.yml')
      break unless File.exist?(env_file)
      YAML.load(File.open(env_file)).each { |key, value| ENV[key.to_s] = value }
    end

    config.load_defaults 5.1

    # if Rails.env.development? || Rails.env.test? FIXME
    Dir['app/_docs/**/*'].each { |p| config.eager_load_paths << p }
    # else
    #   Dir['app/_docs/*.rb', 'app/_docs/v*/**'].each { |p| config.eager_load_paths << p }
    # end


    config.eager_load_paths << Rails.root.join('lib')
    # config.autoload_paths << Rails.root.join('lib')

    # config.cache_store = :redis_store, Settings.redis.cache_url, { expires_in: 30.days, multithread: true }
    config.cache_store = :redis_store, Keys.redis.cache_url, { expires_in: 1.day }

    config.generators do |g|
      g.test_framework :rspec
      g.fixture_replacement :factory_bot, dir: 'spec/factories'
      g.orm :active_record
    end

    config.encoding = 'utf-8'

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

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
