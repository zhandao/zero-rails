class Api::V1::RolesController < Api::V1::BaseController
  include ActiveRecordErrorsRescuer

  def index
    @data = Role.where belongs_to_model: @_model
  end


  def show
    @data = Role.find(@_id)
  end


  def create
    Role.create! permitted
  end


  def update
    Role.find(@_id).update! permitted
  end


  def destroy
    @status = Role.find(@_id).destroy!
  end


  def permissions
    output Role.find(@_id).permissions.pluck :name
  end


  def permissions_modify
    Role.find(@_id).permissions = Permission.where(id: @_permission_ids)
  end
end
