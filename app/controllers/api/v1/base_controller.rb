class Api::V1::BaseController < Api::ApiController
  include LogicSettings

  # before_action :check_store_permission
  #
  ## :nocov:
  # def check_store_permission
  #   return if @store_code.nil?
  #   @store = Store.find_by!(code: @store_code)
  #
  #   current_user&.can! @store.addr
  # end
  ## :nocov:
end
