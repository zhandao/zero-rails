class Api::V1::CategoriesDoc < ApiDoc
  api :index, 'GET list of categories', builder: :cache_index, use: %i[ page rows ], skip: token


  api :nested_list, 'GET nested list of categories', builder: :cache_index, use: none, skip: token


  api :create, 'POST create a category', builder: :success_or_not, use: token do
    form! data: {
                   :name! => { type: String,  desc: 'category name.' },
        :base_category_id => { type: Integer, desc: 'id of the base category. if no pass, it will be a root.' }
    }, pmt: true
  end


  api :update, 'PATCH|PUT update the specified category.', builder: :success_or_not, use: id_and_token do
    form! data: {
                    :name  => { type: String,  desc: 'category name.' },
        :base_category_id  => { type: Integer, desc: 'id of the base category. if pass null, it will be a root.' }
    }, pmt: true
  end


  api :destroy, 'DELETE the specified category', builder: :success_or_not, use: id_and_token
end
