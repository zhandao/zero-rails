class Api::V1::StoresDoc < ApiDoc

  open_api :index, 'GET list of stores.', builder: :cache_index, use: none, skip: token do
    query :page, Integer, desc: '偏移量，从 0 开始', range: { ge: 1 }
    query :rows, Integer, desc: 'per page, 请求的数据条数', range: { ge: 1 }
  end


  open_api :create, 'POST create a store.',
           builder: :success_or_not, use: token do
    form! 'for creating the specified store', data: {
        :code! => { type: String, desc: '商店代号' },
        :addr! => { type: String, desc: '对应的商店地址' },
    }
  end


  open_api :show, 'GET the specified store.', builder: :show, use: id, skip: token


  open_api :update, 'POST update the specified store.', builder: :success_or_not, use: token + id do
    form! 'for updating the specified store', data: {
        :code  => { type: String, desc: '商店代号' },
        :addr  => { type: String, desc: '对应的商店地址' },
    }
  end


  open_api :destroy, 'DELETE the specified store.', builder: :success_or_not, use: token + id
end
