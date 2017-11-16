class Api::V1::UsersController < Api::V1::BaseController
  include ActiveRecordErrorsRescuer

  skip_token only: [:create, :login]
  # skip_callback :process_action, :before, :user_token_verify!

  before_action :can_manage_user!, only: %i[ index show create update destroy ]

  def index
    out 'pong'
  end


  def show
    #
  end


  def show_via_name
    #
  end


  def create
    status = User.create permitted
    UsersError.create_error unless status
  end


  def update
    #
  end


  def destroy
    #
  end


  def login
    user = User.find_by!(name: @_name).try(:authenticate, @_password)
    UsersError.login_failed unless user
    @data = { token: user.token }
  end

  before_action :can_manage_role_permission!, only: %i[ roles permissions roles_modify ]


  def roles
    output User.find(@_id).all_roles
  end


  def permissions
    output User.find(@_id).all_permissions
  end


  def roles_modify
    User.find(@_id).roles = Role.where(id: @_role_ids)
  end
end

