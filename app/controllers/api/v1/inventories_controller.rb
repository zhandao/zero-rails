class Api::V1::InventoriesController < Api::V1::BaseController
  include ActiveRecordErrorsRescuer

  skip_token only: :index

  def index
    @data = Inventory.where good: Good.search(@field, with: @value), store: Store.find_by!(name: @store_name)
  end
end
