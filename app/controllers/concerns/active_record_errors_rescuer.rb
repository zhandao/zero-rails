module ActiveRecordErrorsRescuer
  extend ActiveSupport::Concern

  included do
    # if const_defined? "#{controller_name.camelize}Error" FIXME
    if error_cls?
      (error_cls.errors.values.flatten & ACTIVE_RECORD_ERRORS_MAPPING.keys).each do |error_name|
        rescue_from ACTIVE_RECORD_ERRORS_MAPPING[error_name] do |e|
          # pp e.message
          log_and_render self.class.error_cls.send(error_name)
        end
      end
    end
  end
end
