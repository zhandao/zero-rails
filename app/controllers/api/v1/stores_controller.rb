class Api::V1::StoresController < Api::V1::BaseController
  include ActiveRecordErrorsRescuer

  skip_token only: [:index, :show]

  def index
    @data = Store.all_from_cache
  end


  def create
    Store.create! permitted
  end


  def show
    @datum = Store.all_from_cache[@_id - 2]
  end


  def update
    Store.find(@_id).update! permitted
  end


  def destroy
    @status = Store.find(@_id).destroy
  end
end
