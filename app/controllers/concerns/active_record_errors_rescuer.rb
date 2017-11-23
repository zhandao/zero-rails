module ActiveRecordErrorsRescuer
  def self.included(base)
    base.class_eval do
      before_action do
        @status = true
      end

      rescue_from ::ActiveRecord::ActiveRecordError do |e|
        @status = false
        @error_info = Rails.env.production? ? ERROR_SEVER_ERROR : [ ERROR_ACTIVE_RECORD, e.message ]
        render "#{controller_path}/#{action_name}"
      end

      # if const_defined? "#{controller_name.camelize}Error" FIXME
      if (Object.const_get("#{controller_name.camelize}Error") rescue false)
        error_class = Object.const_get "#{controller_name.camelize}Error"
        (error_class.errors.values.flatten & ACTIVE_RECORD_ERRORS_MAPPING.keys).each do |error_name|
          rescue_from ACTIVE_RECORD_ERRORS_MAPPING[error_name] do |_|
            @status = false
            # @error_info = Rails.env.production? ? error_class.send(error_name, :info).values : [ -100, e.message ]
            @error_info = error_class.send(error_name, :info).values
            render "#{controller_path}/#{action_name}"
          end
        end
      end
    end
  end
end
