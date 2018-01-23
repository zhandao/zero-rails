require 'rails_helper'
require 'dssl/request'

RSpec.describe 'API V1', 'categories', type: :request do
  subject { MultiJson.load(response.body, symbolize_keys: true) }
  let(:data) { subject[:data] }

  let(:user) { create(:user) }
  before { user }

  # permission_mock can?: %i[ 物品管理 ]

  let(:create_params) { { name: 'sub', is_smaller: true, icon_name: 'string', bigger_id: 1 } }

  desc :create, :post, '/api/v1/categories', 'post create a category', :token_needed do
    let(:params) { create_params }

    it_checks_permission
  end

  desc :update, :patch, '/api/v1/categories/1', 'PATCH|PUT update the specified category', :token_needed do
    let(:params) { { name: 'string', is_smaller: 'boolean', icon_name: 'string', bigger_id: 'integer' } }
    it_checks_permission
  end

  desc :destroy, :delete, '/api/v1/categories/1', 'delete the specified category', :token_needed do
    it_checks_permission
  end

  describe 'index' do
    before_when :with_create do
      callto! :create, with: { name: 'base1', bigger_id: 0, is_smaller: false }
      callto! :create, with: { name: 'base2', bigger_id: 0, is_smaller: false }
      callto! :create, with: { name: 'sub11' }
      callto! :create, with: { name: 'sub12' }
    end

    desc :index, :get, '/api/v1/categories', 'get list of categories.' do
      let(:params) { { page: 'integer', rows: 'integer' } }
    end

    desc :nested_list, :get, '/api/v1/categories/list', 'get nested list of categories.' do
      it 'works', :with_create do
        called has_size: 2
        expect(data[0][:sub_categories_info]).to have_size 2
        expect(data[1][:sub_categories_info]).to have_size 0
      end
    end
  end
end
