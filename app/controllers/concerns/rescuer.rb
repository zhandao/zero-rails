module Rescuer
  def self.included(base)
    base.class_eval do
      def self.error_map(mapping)
        mapping.each do |biz_error_name, error|
          rescue_from error do |_|
            log_and_render ApiError.send(biz_error_name).info
          end
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
