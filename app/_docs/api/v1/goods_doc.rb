# frozen_string_literal: true

class Api::V1::GoodsDoc < ApiDoc
  api_dry :all do
    auth :Authorization
  end

  api :index, 'GET list of goods', builder: :index do
    dry only: %i[ created_from created_to search_value page rows ]
    query :view, String, enum!: {
             '(default)': 'all',
         'on sale goods': 'on_sale',
        'off sale goods': 'off_sale'
    }, default: 'all', desc: 'allows:<br/>'

    query :search_field, String, enum: %w[ name category_name unit price ], desc: 'allows:<br/>', as: :field

    query :export, Boolean, desc: 'export result to a Excel'

    # order :view, :search_field, :search_value, :created_from, :created_to, :page, :rows, :export
  end

  api_dry %i[ create update ] do
    form! data: {
        :on_sale => { type: Boolean, permit: true },
        :remarks => { type: String, permit: true },
        :picture => { type: String, is_a: :url, permit: true }
    }
  end

  api :create, 'POST create a good' do
    form! data: {
               :name! => { type: String, permit: true },
        :category_id! => { type: Integer, range: { ge: 1 }, permit: true },
               :unit! => { type: String, permit: true },
              :price! => { type: Float, range: { ge: 0 }, permit: true },
    }
  end

  api :show, 'GET the specified good', builder: :show do
    dry only: :id
  end

  api :update, 'PATCH|PUT update the specified good' do
    dry only: :id

    form! data: {
               :name => { type: String, permit: true },
        :category_id => { type: Integer, range: { ge: 1 }, permit: true },
               :unit => { type: String, permit: true },
              :price => { type: Float, range: { ge: 0 }, permit: true },
    }
  end

  api :destroy, 'DELETE the specified good' do
    dry only: :id
  end

  # /goods/:id/change_onsale
  api :change_onsale, 'POST change sale status of the specified good' do
    path! :id, Integer
  end
end
