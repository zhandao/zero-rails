class Api::V1::CategoriesDoc < ApiDoc

  open_api :index, 'Get list of Categories.', builder: :cache_index, use: none, skip: token do
    query :page, Integer, desc: '偏移量，从 0 开始', range: { ge: 1 }
    query :rows, Integer, desc: 'per page, 请求的数据条数', range: { ge: 1 }
  end


  open_api :nested_list, 'Get nested list of Categories.', builder: :cache_index, use: none, skip: token


  open_api :create, 'Create a Category, returns id of the category that was created.',
           builder: :success_or_not, use: token do
    form! 'for creating a category', data: {
              :name! => { type: String,  desc: '名字' },
        :is_smaller! => { type: Boolean, desc: 'icon name' },
          :icon_name => { type: String,  desc: '是否二级分类?' },
            :base_id => { type: Integer, desc: '一级分类的 id' },
    }
  end


  open_api :update, 'Update a Category.', builder: :success_or_not, use: id_and_token do
    form! 'for creating a category', data: {
              :name  => { type: String,  desc: '名字' },
        :is_smaller  => { type: Boolean, desc: 'icon name' },
         :icon_name  => { type: String,  desc: '是否二级分类?' },
           :base_id  => { type: Integer, desc: '一级分类的 id' },
    }
  end


  open_api :destroy, 'Delete a Category.', builder: :success_or_not, use: id_and_token
end
