module Rescuer
  def self.included(base)
    base.class_eval do
      def self.error_map error_to_bizerror_mapping
        error_to_bizerror_mapping.each do |biz_error_name, error|
          rescue_from error do log_and_render ApiError.send(biz_error_name, :info) end
        end
      end

      rescue_from ::ParamsProcessor::ValidationFailed,
                  ::BusinessError::ZError,
                  ::ZeroRole::VerificationFailed,
                  ::ZeroPermission::InsufficientPermission do |e|
        log_and_render e
      end
    end
  end
end
