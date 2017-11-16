class Api::V1::PermissionsController < Api::V1::BaseController
  include ActiveRecordErrorsRescuer

  def index
    @data = Permission.where belongs_to_model: @_model
  end


  def update
    Permission.find(@_id).update! permitted
  end


  def destroy
    Permission.find(@_id).destroy!
  end
end
