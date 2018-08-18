require 'rails_helper'
require 'dssl/request'

RSpec.describe 'API V1', 'goods', type: :request do
  subject { MultiJson.load(response.body, symbolize_keys: true) }
  let(:data) { subject[:data] }
  path id: 1

  let(:user) { create(:user) }
  before { user; create(:base_category); create(:category) }

  permission_mock can?: [ [:manage, Good] ]

  let(:create_params) { { name: 'good', category_id: 2, unit: 'piece', price: 1 } }

  api :create, :post, '/api/v1/goods', 'post create a good', :token_needed do
    let(:params) { create_params }

    it_checks_permission
  end

  api :index, :get, '/api/v1/goods', 'get list of goods', :token_needed do
    let(:params) { { view: 'string', search_field: 'string', search_value: 'string', created_from: 'string', created_to: 'string', page: 'integer', rows: 'integer', export: 'boolean' } }

    it_checks_permission
  end

  api :show, :get, '/api/v1/goods/{id}', 'get the specified good', :token_needed do
    before { create(:good) }
    it_checks_permission
  end

  api :update, :patch, '/api/v1/goods/{id}', 'update the specified good', :token_needed do
    let(:params) { { on_sale: 'integer', remarks: 'boolean', picture: 'string', name: 'string', category_id: 'string', unit: 'integer', price: 'string' } }
    before { create(:good) }

    it_checks_permission
  end

  api :destroy, :delete, '/api/v1/goods/{id}', 'delete the specified good', :token_needed do
    before { create(:good) }
    it_checks_permission
  end

  api :change_onsale, :post, '/api/v1/goods/{id}/change_onsale', 'post change sale status of the specified good', :token_needed do
    before { create(:good) }

    it_checks_permission

    it 'works' do
      expect_any_instance_of(Good).to receive(:change_onsale).and_return(true)
      requests get: 200
    end
  end
end
