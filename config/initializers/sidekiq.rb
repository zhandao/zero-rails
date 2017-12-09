if Rails.env.test?
  # require 'sidekiq/testing'
end

if Rails.env.development?
  # Sidekiq.default_worker_options = { retry: false }
end

if Rails.env.staging? || Rails.env.production?
  # https://github.com/mperham/sidekiq/wiki/Using-Redis
  Sidekiq.configure_server do |config|
    config.redis = { url: Keys.redis.sidekiq_url }
  end

  Sidekiq.configure_client do |config|
    config.redis = { url: Keys.redis.sidekiq_url }
  end
end

