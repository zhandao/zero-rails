class Api::V1::InventoriesController < Api::V1::BaseController
  include ActiveRecordErrorsRescuer

  def index
    @data = Inventory.where good: Good.search_by(@field, @value), store: Store.find_by!(name: @store_name)
  end
end
