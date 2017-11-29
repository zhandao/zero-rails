require_relative 'boot'

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module RailsApi
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.

    config.before_configuration do
      env_file = File.join(Rails.root, 'config', 'local_env.yml')
      YAML.load(File.open(env_file)).each do |key, value|
        ENV[key.to_s] = value
      end if File.exists?(env_file)
    end

    config.load_defaults 5.1
    # config.eager_load_paths << Rails.root.join('app') # TODO
    Dir["#{Rails.root}/app/biz_errors/**/*"].each { |p| config.eager_load_paths << p }
    config.eager_load_paths << "#{Rails.root}/app/_docs/rspec_docs/"
    config.eager_load_paths << "#{Rails.root}/app/_docs/model_docs/"
    # config.eager_load_paths << Rails.root.join('app/controllers/api')
    config.eager_load_paths << Rails.root.join('lib')

    config.generators do |g|
      g.test_framework :rspec,
                       fixtures: true,
                       view_specs: false,
                       helper_specs: false,
                       routing_specs: false,
                       controller_specs: true,
                       request_specs: false

      g.fixture_replacement :factory_bot, dir: 'spec/factories'
      g.orm :active_record
    end

    config.encoding = "utf-8"

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
  end
end
