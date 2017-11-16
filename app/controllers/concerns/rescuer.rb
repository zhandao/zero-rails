module Rescuer
  def self.included(base)
    base.class_eval do
      rescue_from ::ParamsProcessor::ValidationFailed,
                  ::BusinessError::ZError,
                  ::ZeroRole::VerificationFailed,
                  ::ZeroPermission::InsufficientPermission do |e|
        log_and_render e
      end
    end
  end
end
