require 'rails_helper'
require 'dssl/request'

RSpec.describe 'API V1', 'stores', type: :request do
  subject { MultiJson.load(response.body, symbolize_keys: true) }
  let(:data) { subject[:data] }
  path id: 1

  let(:user) { create(:user) }
  before { user }

  desc :index, :get, '/api/v1/stores', 'get list of stores' do
    let(:params) { { page: 'integer', rows: 'integer' } }
  end

  desc :create, :post, '/api/v1/stores', 'post create a store', :token_needed do
    let(:params) { { name: 'string', address: 'string' } }
  end

  desc :show, :get, '/api/v1/stores/{id}', 'get a store' do
  end

  desc :update, :patch, '/api/v1/stores/{id}', 'update the specified store', :token_needed do
    let(:params) { { name: 'integer', address: 'string' } }
  end

  desc :destroy, :delete, '/api/v1/stores/{id}', 'delete the specified store', :token_needed do
  end
end
