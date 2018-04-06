class Api::V1::StoresDoc < ApiDoc
  api_dry %i[ create update destroy ] do
    auth :Token
  end


  api :index, 'GET list of stores', builder: :cache_index, use: %i[ page rows ]


  api :create, 'POST create a store', builder: :success_or_not do
    form! data: {
           :name! => String,
        :address! => String
    }, pmt: true
  end


  api :show, 'GET the specified store', builder: :show, use: id


  api :update, 'POST update the specified store', builder: :success_or_not, use: id do
    form! data: {
           :name  => String,
        :address  => String
    }, pmt: true
  end


  api :destroy, 'DELETE the specified store', builder: :success_or_not, use: id
end
