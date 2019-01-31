# frozen_string_literal: true

class Api::V1::UsersController < Api::V1::BaseController
  include ActiveRecordErrorsRescuer

  skip_token only: %i[ create login ]
  # before_action :can_manage_user!, only: %i[ index show create update destroy ]
  # to_access %i[ index show create update destroy ], should_can: :manage_user
  # if_can :manage_user, allow: %i[ index show update destroy ]
  if_can :manage_role_permission, allow_matched: %i[ role permission ]

  def index
    build_with data: User.all
  end

  def show
    #
  end

  def show_via_name
    #
  end

  def create
    user = User.create! permitted
    ok_with token: user.token
  end

  def update
    check @user.update! permitted
  end

  def destroy
    check @user.destroy
  end

  # FIXME: fix find_by! => NotF but not rescue
  def login
    user = User.find_by(name: @name).try(:authenticate, @password)
    UsersError.login_failed! unless user
    ok_with token: user.token
  end

  def logout
    #
  end
end
