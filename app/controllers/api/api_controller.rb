require 'params_processor' # TODO

class Api::ApiController < ActionController::API
  include ActionController::Caching
  include Zero::Log, OutPut
  include Rescuer
  include ParamsProcessor
  include MakeSure
  include Token

  before_action :user_token_verify!

  before_action :process_params!

  rescue_from ::ParamsProcessor::ValidationFailed,
              ::BusinessError::ZError,
              ::IAmICan::Role::VerificationFailed,
              ::IAmICan::Permission::InsufficientPermission do |e|
    log_and_render e
  end

  error_map(
         invalid_token: JWT::DecodeError,
            role_error: IAmICan::Role::VerificationFailed,
      permission_error: IAmICan::Permission::InsufficientPermission
  )

  def self.skip_token options = { }
    skip_before_action :user_token_verify!, options
  end

  def self.error_cls(rt = nil)
    "#{controller_name.camelize}Error".constantize
  rescue
    rt || ApiError
  end

  def self.error_cls?; error_cls(false) end

  helper_method :render_error

  def render_error # from are rescuer
    error_class  = "#{controller_name.camelize}Error".constantize rescue nil
    if error_class.respond_to?(action_error = "#{action_name}_failed")
      @error_info = error_class.send(action_error).info.values
    end
    @_code, @_msg, _ = @error_info
  end

  private

  def log_and_render(e)
    log_error e
    # ren Rails.env.production? ? { code: 500, msg: 'something is wrong' } : e
    output e
  end
end
