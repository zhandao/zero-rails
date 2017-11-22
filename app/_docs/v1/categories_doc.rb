class Api::V1::CategoriesDoc < ApiDoc

  open_api :index, 'GET list of categories.', builder: :cache_index, use: [:page, :rows], skip: token


  open_api :nested_list, 'GET nested list of categories.', builder: :cache_index, use: none, skip: token


  open_api :create, 'POST create a category.', builder: :success_or_not, use: token do
    form! 'for creating the specified category', data: {
              :name! => { type: String,  desc: '名字' },
        :is_smaller! => { type: Boolean, desc: 'icon name' },
          :icon_name => { type: String,  desc: '是否二级分类?' },
            :base_id => { type: Integer, desc: '一级分类的 id' },
    }
  end


  open_api :update, 'PATCH update the specified category.', builder: :success_or_not, use: id_and_token do
    form! 'for updating the specified category', data: {
              :name  => { type: String,  desc: '名字' },
        :is_smaller  => { type: Boolean, desc: 'icon name' },
         :icon_name  => { type: String,  desc: '是否二级分类?' },
           :base_id  => { type: Integer, desc: '一级分类的 id' },
    }
  end


  open_api :destroy, 'DELETE the specified category.', builder: :success_or_not, use: id_and_token
end
