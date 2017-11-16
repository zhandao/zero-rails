require 'params_processor' # TODO
require './lib/monkey_patches/array' # TODO

class Api::ApiController < ActionController::API
  include OpenApi::DSL, Zero::Log, Rescuer
  include OutPut, AutoGenDoc, ParamsProcessor
  include RolePermissionMapper

  include Token
  before_action :user_token_verify!

  def self.skip_token options = { }
    skip_before_action :user_token_verify!, options
  end

  before_action :validate_params!
  before_action :convert_params_type
  before_action :set_permitted

  rescue_from JWT::DecodeError do log_and_render ApiError.invalid_token :info end
  rescue_from ZeroRole::VerificationFailed do log_and_render ApiError.role_error :info end
  rescue_from ZeroPermission::InsufficientPermission do log_and_render ApiError.permission_error :info end

  private

  def log_and_render(e)
    log_error e
    # ren Rails.env.production? ? { code: 500, msg: 'something is wrong' } : e
    output e
  end

  def input(key = nil)
    key.present? ? params[key] : (@zpa ||= Zero::ParamsAgent.tap { |zpa| zpa.params = params })
  end

  permission_map manage_role_permission: nil, manage_user: nil

  def can_manage_role_permission!
    make_sure current_user, :can!, :manage_role_permission
  end

  def can_manage_user!
    make_sure current_user, :can!, :manage_user
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
