# frozen_string_literal: true

class Api::V1::StoresDoc < ApiDoc
  api_dry %i[ create update destroy ] do
    auth :Authorization
  end

  api :index, 'GET list of stores', builder: :cache_index do
    dry only: %i[ page rows ]
  end

  api :create, 'POST create a store' do
    form! data: {
           :name! => { type: String, permit: true },
        :address! => { type: String, permit: true }
    }
  end

  api :show, 'GET the specified store', builder: :show do
    dry only: :id
  end

  api :update, 'POST update the specified store' do
    dry only: :id
    form! data: {
           :name  => { type: String, permit: true },
        :address  => { type: String, permit: true }
    }
  end

  api :destroy, 'DELETE the specified store' do
    dry only: :id
  end
end
