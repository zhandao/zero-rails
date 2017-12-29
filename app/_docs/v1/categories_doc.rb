class Api::V1::CategoriesDoc < ApiDoc
  api :index, 'GET list of categories.', builder: :cache_index, use: %i[ page rows ], skip: token


  api :nested_list, 'GET nested list of categories.', builder: :cache_index, use: none, skip: token


  api :create, 'POST create a category.', builder: :success_or_not, use: token do
    form! data: {
              :name! => { type: String,  desc: '名字' },
        :is_smaller! => { type: Boolean, desc: 'icon name' },
          :icon_name => { type: String,  desc: '是否二级分类?' },
            :base_id => { type: Integer, desc: '一级分类的 id' }
    }, pmt: true
  end


  api :update, 'PATCH update the specified category.', builder: :success_or_not, use: id_and_token do
    form! data: {
              :name  => { type: String,  desc: '名字' },
        :is_smaller  => { type: Boolean, desc: 'icon name' },
         :icon_name  => { type: String,  desc: '是否二级分类?' },
           :base_id  => { type: Integer, desc: '一级分类的 id' }
    }, pmt: true
  end


  api :destroy, 'DELETE the specified category.', builder: :success_or_not, use: id_and_token
end
