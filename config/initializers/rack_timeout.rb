unless Rails.env.development?
  Rails.application.config.middleware.insert_before Rack::Runtime, Rack::Timeout, service_timeout: 5 # seconds
  Rack::Timeout::Logger.disable
end
