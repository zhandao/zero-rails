class Api::V1::StoresDoc < ApiDoc
  api_dry %i[ create update destroy ] do
    auth :Authorization
  end

  api :index, 'GET list of stores', builder: :cache_index, use: %i[ page rows ]

  api :create, 'POST create a store' do
    form! data: {
           :name! => String,
        :address! => String
    }, pmt: true
  end

  api :show, 'GET the specified store', builder: :show, use: id

  api :update, 'POST update the specified store', use: id do
    form! data: {
           :name  => String,
        :address  => String
    }, pmt: true
  end

  api :destroy, 'DELETE the specified store', use: id
end
