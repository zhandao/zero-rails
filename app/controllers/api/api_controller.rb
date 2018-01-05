require 'params_processor' # TODO
require './lib/monkey_patches/array' # TODO

class Api::ApiController < ActionController::API
  include ActionController::Caching
  include Zero::Log, OutPut
  include OpenApi::DSL, AutoGenDoc
  include Rescuer
  include ParamsProcessor
  include MakeSure
  include Token

  before_action :user_token_verify!

  def self.skip_token options = { }
    skip_before_action :user_token_verify!, options
  end

  before_action :process_params!

  error_map(
         invalid_token: JWT::DecodeError,
            role_error: ZeroRole::VerificationFailed,
      permission_error: ZeroPermission::InsufficientPermission
  )

  def self.error_cls(rt = nil)
    "#{controller_name.camelize}Error".constantize
  rescue
    rt || ApiError
  end

  def self.error_cls?; error_cls(false) end

  private

  def log_and_render(e)
    log_error e
    # ren Rails.env.production? ? { code: 500, msg: 'something is wrong' } : e
    output e
  end

  def input(key = nil)
    key.present? ? params[key] : (@zpa ||= Zero::ParamsAgent.tap { |zpa| zpa.params = params })
  end
end
