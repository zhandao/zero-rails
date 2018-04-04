class Api::V1::StoresDoc < ApiDoc
  api :index, 'GET list of stores', builder: :cache_index, use: %i[ page rows ], skip: token


  api :create, 'POST create a store', builder: :success_or_not, use: token do
    form! data: {
           :name! => String,
        :address! => String
    }, pmt: true
  end


  api :show, 'GET the specified store', builder: :show, use: id, skip: token


  api :update, 'POST update the specified store', builder: :success_or_not, use: token + id do
    form! data: {
           :name  => String,
        :address  => String
    }, pmt: true
  end


  api :destroy, 'DELETE the specified store', builder: :success_or_not, use: token + id
end
