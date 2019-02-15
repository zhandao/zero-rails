Rails.application.configure do
  config.lograge.keep_original_rails_log = true

  config.lograge.enabled = Rails.env.test? ? false : true

  app_name = Rails.app_class.to_s.underscore.split('/')[0]

  unless Rails.env.test?
    config.lograge.logger =
        ActiveSupport::Logger.new(
            "/data/logs/logstash_#{app_name}_#{Rails.env}}.log",
            leave_size = 6, leave_size = 200 * 1048576
        )
  end

  config.lograge.base_controller_class = 'ActionController::API'

  config.lograge.custom_payload do |controller|
    result = Oj.load(controller.response.body, symbol_keys: true)[:result] rescue { }

    {
        params: controller.params.reject { |k| k.in? %w[ controller action api ] },
        host: controller.request.host,
        ip: controller.request.remote_ip,
        user: controller.try(:current_admin)&.id || '',
        # jwt: controller.try(:token) || '',
        response_code: controller.response.code,
        response_result: result
    }
  end

  config.lograge.custom_options = lambda do |event|
    {
        time: event.time.to_s(:standard),
        **event.payload.slice(:ip, :host, :params, :user, :response_code, :response_result)
    }
  end

  config.lograge.ignore_custom = lambda do |event|
    # return true here if you want to ignore based on the event
    # event.payload[:controller].in? %w[HomeController]
  end

  config.lograge.ignore_actions = ['HomeController#health']

  config.lograge.formatter = Lograge::Formatters::Logstash.new
end
