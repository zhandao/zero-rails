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

  before_action :validate_params!
  before_action :convert_params_type
  before_action :set_permitted

  error_map(
         invalid_token: JWT::DecodeError,
            role_error: ZeroRole::VerificationFailed,
      permission_error: ZeroPermission::InsufficientPermission
  )

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


# class ApiErrorMapper
#   extend BusinessError::ErrorMapper
#
#   rules({
#       cool: {
#           if: 'obj.nil? == false',
#           do: proc { puts ApiError.send :invalid_param, :info },
#           raise: :invalid_param,
#           error: ApiError
#       }
#   })
# end
