class Api::V1::PermissionsController < Api::V1::BaseController
  include ActiveRecordErrorsRescuer

  if_can :manage_role_permission, allow: :all

  def index
    @data = Permission.all
  end

  def create
    Permission.create! permitted
  end

  def update
    @permission.update! permitted
  end


  def destroy
    @permission.destroy!
  end
end
