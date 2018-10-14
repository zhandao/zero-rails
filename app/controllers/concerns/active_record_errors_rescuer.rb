module ActiveRecordErrorsRescuer
  extend ActiveSupport::Concern

  included do
    Error::Api rescue next
    ACTIVE_RECORD_ERRORS_MAPPING.keys.each do |error_name|
      rescue_from ACTIVE_RECORD_ERRORS_MAPPING[error_name] do
        log_and_render Error::Api.send(error_name)
      end
    end
  end
end
