class Api::V1::StoresController < Api::V1::BaseController
  include ActiveRecordErrorsRescuer

  skip_token only: %i[ index show ]

  def index
    @data = Store.all
  end


  def create
    Store.create! permitted
  end


  def show
    @datum = @store
  end


  def update
    @store.update! permitted
  end


  def destroy
    @status = @store.destroy
  end
end
