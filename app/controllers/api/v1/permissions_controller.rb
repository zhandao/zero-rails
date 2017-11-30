class Api::V1::PermissionsController < Api::V1::BaseController
  include ActiveRecordErrorsRescuer

  if_can :manage_role_permission, allow: :CRUDI

  def index
    @data = Permission.where belongs_to_model: @model
  end


  def update
    @permission.update! permitted
  end


  def destroy
    @permission.destroy!
  end
end
