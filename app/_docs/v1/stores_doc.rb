class Api::V1::StoresDoc < ApiDoc
  api :index, 'GET list of stores.', builder: :cache_index, use: none, skip: token do
    query :page, Integer, desc: '偏移量，从 0 开始', range: { ge: 1 }
    query :rows, Integer, desc: 'per page, 请求的数据条数', range: { ge: 1 }
  end


  api :create, 'POST create a store.',
           builder: :success_or_not, use: token do
    form! data: {
           :name! => { type: String, desc: '商店名' },
        :address! => { type: String, desc: '商店地址' }
    }, pmt: true
  end


  api :show, 'GET the specified store.', builder: :show, use: id, skip: token


  api :update, 'POST update the specified store.', builder: :success_or_not, use: token + id do
    form! data: {
           :name  => { type: String, desc: '商店名' },
        :address  => { type: String, desc: '商店地址' }
    }, pmt: true
  end


  api :destroy, 'DELETE the specified store.', builder: :success_or_not, use: token + id
end
