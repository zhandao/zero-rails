class Api::V1::InventoriesController < Api::V1::BaseController
  # include ActiveRecordErrorsRescuer
  include Export

  skip_token only: [:index]

  def index
    @data = Good.search_by(@_field, @_value).ordered.get(:inventories) \
            & Store.find_by!(code: @_store_code).inventories
    export_inventories if @_export
  end
end
