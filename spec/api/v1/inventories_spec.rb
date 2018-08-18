require 'rails_helper'
require 'dssl/request'

RSpec.describe 'API V1', 'inventories', type: :request do
  subject { MultiJson.load(response.body, symbolize_keys: true) }
  let(:data) { subject[:data] }
  path id: 1

  skippable_before do
    create(:store)
    prepare_goods
  end

  api :index, :get, '/api/v1/inventories', 'get list of inventories' do
    let(:params) { { store_name: 'store' } }

    it { requests has_size: 5 }
  end
end
