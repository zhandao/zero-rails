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
              ::BusinessError::Error,
              ::IAmICan::VerificationFailed,
              ::IAmICan::InsufficientPermission do |e|
    log_and_render e
  end

  error_map(
         invalid_token: JWT::DecodeError,
            role_error: IAmICan::VerificationFailed,
      permission_error: IAmICan::InsufficientPermission
  )

  def self.skip_token options = { }
    skip_before_action :user_token_verify!, options
  end

  def self.error_cls(rt = nil)
    "Error#{controller_name.camelize}".constantize
  rescue
    rt || Error::Api
  end

  delegate :error_cls, to: self

  def self.error_cls?; error_cls(false) end

  def self.error_cls?; error_cls(false) end

  # check api status
  def check result
    return ok if result
    error_cls.send("#{action_name}_failed!")
  end

  private

  def log_and_render(e)
    log_error e
    # ren Rails.env.production? ? { code: 500, msg: 'something is wrong' } : e
    output e
  end
end
