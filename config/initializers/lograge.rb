Rails.application.configure do

  config.lograge.keep_original_rails_log = true

  config.lograge.enabled = Rails.env.test? ? false : true
  config.lograge.logger = ActiveSupport::Logger.new "/data/logs/logstash_lograge_zero-rails_#{Rails.env}.log"

  config.lograge.base_controller_class = 'ActionController::API'

  config.lograge.custom_payload do |controller|
    {
        params: controller.params.reject { |k| k.in? %w[ controller action api ] },
        host: controller.request.host,
        ip: controller.request.remote_ip,
        user: controller.try(:current_admin)&.id || '',
        jwt: controller.try(:token) || ''
    }
  end

  config.lograge.custom_options = lambda do |event|
    {
        ip: event.payload[:ip],
        host: event.payload[:host],
        time: event.time.to_s(:standard),
        params: event.payload[:params],
        user: event.payload[:user],
        jwt: event.payload[:jwt]

    }
  end

  config.lograge.formatter = Lograge::Formatters::Logstash.new
end
