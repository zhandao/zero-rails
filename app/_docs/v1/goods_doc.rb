class Api::V1::GoodsDoc < ApiDoc
  api_dry :all do
    auth :Token
  end


  api :index, 'GET list of goods', builder: :index, use: %i[ created_from created_to search_value page rows ] do
    desc 'GET list of goods', view!: 'allows:<br/>', search_field!: 'allows:<br/>'

    query :view, String, enum!: {
             '(default)': 'all',
         'on sale goods': 'on_sale',
        'off sale goods': 'off_sale'
    }, dft: 'all'

    query :search_field, String, enum: %w[ name category_name unit price ], as: :field

    query :export, Boolean, desc: 'export result to a Excel'

    order :view, :search_field, :search_value, :created_from, :created_to, :page, :rows, :export
  end


  api_dry %i[ create update ] do
    form! data: {
        :on_sale => { type: Boolean },
        :remarks => { type: String },
        :picture => { type: String, is: :url }
    }, pmt: true
  end


  api :create, 'POST create a good', builder: :success_or_not do
    form! data: {
               :name! => { type: String },
        :category_id! => { type: Integer, range: { ge: 1 } },
               :unit! => { type: String },
              :price! => { type: Float, range: { ge: 0 } },
    }, pmt: true
  end


  api :show, 'GET the specified good', builder: :show, use: id


  api :update, 'PATCH|PUT update the specified good', builder: :success_or_not, use: id do
    form! data: {
               :name => { type: String },
        :category_id => { type: Integer, range: { ge: 1 } },
               :unit => { type: String },
              :price => { type: Float, range: { ge: 0 } },
    }, pmt: true
  end


  api :destroy, 'DELETE the specified good', builder: :success_or_not, use: id


  # /goods/:id/change_onsale
  api :change_onsale, 'POST change sale status of the specified good', builder: :success_or_not do
    path! :id, Integer
  end
end
