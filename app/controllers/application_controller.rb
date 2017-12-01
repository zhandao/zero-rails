class ApplicationController < ActionController::Base
  include Zero::Log
  # include BusinessError::ErrorProcessor
  # generate_make_sure :not_null

  # Authentication for ActiveAdmin
  def authenticate_admin_user!
    authenticate_or_request_with_http_basic do |user_name, password|
      user_name == Settings.active_admin.user_name && password == Settings.active_admin.password
    end
  end

  private

  def pa(key = nil)
    key.present? ? params[key] : (@zpa ||= Zero::ParamsAgent.tap { |zpa| zpa.params = params })
  end

  alias input pa

  def log_and_render(e)
    log_error e
    # ren Rails.env.production? ? { code: 500, msg: 'something is wrong' } : e
    output code: 500, msg: 'Internal Server Error'
  end
end
