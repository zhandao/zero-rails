# frozen_string_literal: true

class Api::V1::InventoriesDoc < ApiDoc
  api :index, 'GET list of inventories', builder: :index do
    dry only: %i[ created_from created_to search_value page rows ]
    query! :store_name,   String
    query  :search_field, String, desc: 'allows:<br/>', enum!: %w[ name category_name unit price ], as: :field # good_name ..
  end
end
