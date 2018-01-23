require 'rails_helper'
require 'dssl/request'

RSpec.describe 'API V1', 'inventories', type: :request do
  subject { MultiJson.load(response.body, symbolize_keys: true) }
  let(:data) { subject[:data] }
  path id: 1

  skippable_before do
    create(:floor)
    prepare_goods
    create_list(:record, 10, good_id: 1)
    create_list(:record, 7, good_id: 2)
    create_list(:record, 1, good_id: 4)
  end

  desc :index, :get, '/api/v1/inventories', 'get list of inventories.', :token_needed do
    let(:params) { { view: 'high_freq_get', floor_code: '1' } }

    it { called has_size: 3 }
    it { called with: { view: 'get' }, has_size: 5 }
  end
end
