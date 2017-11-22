class Api::V1::InventoriesController < Api::V1::BaseController
  # include ActiveRecordErrorsRescuer
  include Export

  skip_token only: [:index]

  def index
    @data = Inventory.where good: Good.search_by(@_field, @_value), store: Store.find_by!(code: @_store_code)
    export_inventories if @_export
  end
end
