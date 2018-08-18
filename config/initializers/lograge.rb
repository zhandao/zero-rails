Rails.application.configure do
  config.lograge.keep_original_rails_log = true

  config.lograge.enabled = Rails.env.test? ? false : true

  config.lograge.logger =
      ActiveSupport::Logger.new "/data/logs/logstash_#{$app_name}_#{Rails.env}.log" unless Rails.env.test?

  config.lograge.base_controller_class = 'ActionController::API'

  config.lograge.custom_payload do |controller|
    {
        params: controller.params.reject { |k| k.in? %w[ controller action api ] },
        host: controller.request.host,
        ip: controller.request.remote_ip,
        user: controller.try(:current_admin)&.id || '',
        jwt: controller.try(:token) || '',
        response_code: controller.response.code,
        response_body: (MultiJson.load(controller.response.body).except('language', 'timestamp') rescue {})
    }
  end

  config.lograge.custom_options = lambda do |event|
    {
        time: event.time.to_s(:standard),
        **event.payload.slice(:ip, :host, :params, :user, :jwt, :response_code, :response_body)
    }
  end

  config.lograge.formatter = Lograge::Formatters::Logstash.new
end
