class Api::V1::UsersController < Api::V1::BaseController
  include ActiveRecordErrorsRescuer

  skip_token only: %i[ create login ]
  # before_action :can_manage_user!, only: %i[ index show create update destroy ]
  # to_access %i[ index show create update destroy ], should_can: :manage_user
  # if_can :manage_user, allow: %i[ index show update destroy ]
  if_can :manage_role_permission, allow_matched: %i[ role permission ]

  def index
    @data = User.all
  end


  def show
    #
  end


  def show_via_name
    #
  end


  def create
    User.create! permitted
  end


  def update
    @user.update! permitted
  end


  def destroy
    @user.destroy
  end


  # FIXME: fix find_by! => NotF but not rescue
  def login
    user = User.find_by(name: @name).try(:authenticate, @password)
    UsersError.login_failed! unless user
    @data = { token: user.token }
  end

  def logout
    #
  end

  def roles
    output @user.roles.pluck(:name) # @user.all_roles
  end

  def permissions
    output @user.all_permissions
  end


  def roles_modify
    @user.roles = Role.where(id: @role_ids)
  end
end

