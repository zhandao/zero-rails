class Api::V1::InventoriesController < Api::V1::BaseController
  # include ActiveRecordErrorsRescuer
  include Export

  skip_token only: [:index]

  def index
    @data = Inventory.where good: Good.search_by(@field, @value), store: Store.find_by!(name: @store_name)
    export_inventories if @export
  end
end
