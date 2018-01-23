require 'rails_helper'
require 'dssl/request'

RSpec.describe 'API V1', 'goods', type: :request do
  subject { MultiJson.load(response.body, symbolize_keys: true) }
  let(:data) { subject[:data] }
  path id: 1

  let(:user) { create(:user) }
  before { user; create(:base_category); create(:category) }

  permission_mock can?: %i[ 物品管理 ]

  let(:create_params) { { name: 'good', bigger_cate_id: 1, smaller_cate_id: 2, unit: 'piece', price: 1 } }

  desc :create, :post, '/api/v1/goods', 'post create a good', :token_needed do
    let(:params) { create_params }

    it_checks_permission
  end

  desc :index, :get, '/api/v1/goods', 'get list of goods', :token_needed do
    let(:params) { { created_start_at: 'string', created_end_at: 'string', value: 'string', page: 'integer', rows: 'integer', view: 'string', search_type: 'string', export: 'boolean' } }

    it_checks_permission
  end

  desc :show, :get, '/api/v1/goods/{id}', 'get the specified good', :token_needed do
    it_checks_permission
  end

  desc :update, :patch, '/api/v1/goods/{id}', 'update the specified good', :token_needed do
    let(:params) { { need_approve: 'integer', need_return: 'boolean', on_sale: 'boolean', part_number: 'boolean', brand: 'string', specifications: 'string', remarks: 'string', pic_path: 'string', name: 'string', bigger_cate_id: 'string', smaller_cate_id: 'integer', unit: 'integer', price: 'string' } }

    it_checks_permission
  end

  desc :destroy, :delete, '/api/v1/goods/{id}', 'delete the specified good', :token_needed do
    it_checks_permission
  end

  desc :change_online, :post, '/api/v1/goods/{id}/change_online', 'Change online status of the specified good', :token_needed do
    it_checks_permission

    before_when(:with_create) { callto! :create }

    it 'works', :with_create do
      expect_any_instance_of(Good).to receive(:change_online).and_return(true)
      called get: 200
    end
  end
end
