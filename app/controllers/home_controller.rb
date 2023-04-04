# frozen_string_literal: true

class HomeController < ApplicationController
  before_action :authenticate_admin_user!, only: %i[ apidoc open_api ]

  def apidoc
    render 'home/index.html'
  end

  def open_api
    return error_404 unless (doc = params[:doc]).in?(OpenApi.docs.keys)
    render file: "#{Rails.root}/#{OpenApi::Config.file_output_path}/#{doc}.json", status: :ok, layout: false
  end

  def error_404
    render file: "#{Rails.root}/public/404.html", status: :not_found, layout: false
  end
end
