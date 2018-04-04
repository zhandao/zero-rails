class Api::V1::RolesController < Api::V1::BaseController
  include ActiveRecordErrorsRescuer

  if_can :manage_role_permission, allow: :all

  def index
    @data = Role.all
  end


  def show
    @datum = @role
  end


  def create
    Role.create! permitted
  end


  def update
    @role.update! permitted
  end


  def destroy
    @role.destroy!
  end


  def permissions
    # TODO: 非 db
    output @role.permissions.pluck :name
  end


  def permissions_modify
    @role.permissions = Permission.where id: @permission_ids
  end
end
