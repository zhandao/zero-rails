module ActiveRecordErrorsRescuer
  def self.included(base)
    base.class_eval do
      before_action do
        @status = true
      end # TODO: status == nil || true is ok, and remove the filter

      # if const_defined? "#{controller_name.camelize}Error" FIXME
      if error_cls?
        (error_cls.errors.values.flatten & ACTIVE_RECORD_ERRORS_MAPPING.keys).each do |error_name|
          rescue_from ACTIVE_RECORD_ERRORS_MAPPING[error_name] do |e|
            @status = false
            # pp e.message
            @error_info = self.class.error_cls.send(error_name).info.values
            log_error @error_info
            render "#{controller_path}/#{action_name}"
          end
        end
      end
    end
  end
end
