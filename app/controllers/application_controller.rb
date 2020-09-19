# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Zero::Log, OutPut

  # Authentication not only for ActiveAdmin
  def authenticate_admin_user!
    authenticate_or_request_with_http_basic do |user_name, password|
      user_name == Keys.admin.user_name && password == Keys.admin.password
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
    output 500, 'Internal Server Error'
  end
end
