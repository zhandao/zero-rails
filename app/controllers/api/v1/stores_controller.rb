class Api::V1::StoresController < Api::V1::BaseController
  include ActiveRecordErrorsRescuer

  skip_token only: %i[ index show ]

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
    @store.update! permitted
  end


  def destroy
    @status = @store.destroy
  end
end
