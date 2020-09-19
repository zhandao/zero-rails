# frozen_string_literal: true

class Api::V1::CategoriesDoc < ApiDoc
  api_dry %i[ create update destroy ] do
    auth :Authorization
  end

  api :index, 'GET list of categories', builder: :cache_index do
    dry only: %i[ page rows ]
  end

  api :nested_list, 'GET nested list of categories', builder: :cache_index

  api :create, 'POST create a category' do
    form! data: {
                   :name! => { type: String,  desc: 'category name.', permit: true },
        :base_category_id => { type: Integer, desc: 'id of the base category. if no pass, it will be a root.', permit: true }
    }
  end

  api :update, 'PATCH|PUT update the specified category.' do
    dry only: :id
    form! data: {
                    :name  => { type: String,  desc: 'category name.', permit: true },
        :base_category_id  => { type: Integer, desc: 'id of the base category. if pass null, it will be a root.', permit: true }
    }
  end

  api :destroy, 'DELETE the specified category' do
    dry only: :id
  end
end
