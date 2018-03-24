# require 'rails_helper'
# require 'dssl/request'
#
# RSpec.describe 'API V1', 'records', type: :request do
#   subject { MultiJson.load(response.body, symbolize_keys: true) }
#
#   before do
#     allow_any_instance_of(Api::V1::RecordsController).to receive(:info_from_fingerprint).and_return(1000)
#     allow_any_instance_of(Api::V1::RecordsController).to receive(:info_from_sec_depart).and_return(
#         app_name: 'tom', dep: 'internet'
#     )
#     create(:store)
#     create(:store, name: 'store2')
#   end
#
#   let(:create_params) { { store_name: 'store2', fingerprint: 'string', app_type: 'get', data: [{ good_id: 1, app_count: 2, total_prices: 2 }] } }
#   let(:inventory) { Inventory.find_by(store_id: 2, good_id: 1) }
#
#   api :create, :post, '/api/v1/records', '创建一条记录，当人们提交领用需求清单时请求该接口' do
#     let(:params) { create_params }
#     before { prepare_goods inv: 10 }
#
#     it 'works' do
#       requested get: 200
#       expect(Record.last).to have_attributes(store_id: 2, good_id: 1, app_type: 'get', app_id: 1000, app_name: 'tom')
#       expect(inventory.amount).to eq 8
#     end
#
#     context 'when inv is not enough' do
#       it 'transaction abort' do
#         request with: { data: [{ good_id: 1, app_count: 2, total_prices: 2 }, { good_id: 1, app_count: 10, total_prices: 10 }] },
#                 get: 600
#         expect(Record.count).to eq 0
#         expect(inventory.amount).to eq 10
#       end
#     end
#   end
#
#   api :index, :get, '/api/v1/records', 'get list of records (员工领借记录)' do
#     let(:params) { { store_name: 'store2', search_field: 'name', value: 'string', export: false } }
#     before do
#       prepare_goods name: ('aaa'..'aae').to_a
#       req_to :create, with: { data: [{ good_id: 1 }, { good_id: 2 }, { good_id: 5 }].map { |h| h.merge!(app_count: 1, total_prices: 1) } }
#     end
#
#     context 'search by good name' do
#       it { request with: { value: 'aa' }, has_size: 3 }
#       it { request with: { value: 'ac' }, has_size: 0 }
#     end
#
#     context 'search by applicant info' do
#       it { request with: { search_field: 'fingerprint' }, has_size: 3 }
#     end
#   end
#
#   # api :take, :post, '/api/v1/records/take', '确认员工已到前台领取物品（当前版本不需调用）' do
#   #   let(:params) { { fingerprint: 'string' } }
#   # end
#
#   api :return, :post, '/api/v1/records/return', '确认员工已到前台归还物品' do
#     let(:params) { { ids: [1], app_id: 1000 } }
#     before { prepare_goods inv: 10 }
#
#     it 'works' do
#       req_to :create, with: { app_type: 'borrow' }
#       expect(inventory.amount).to eq 8
#       requested get: 200
#       expect(inventory.reload.amount).to eq 10
#       expect(Record.last.return_at).not_to be_nil
#     end
#
#     context 'when returning a returned record' do
#       it 'does nothing' do
#         req_to :create, with: { app_type: 'borrow' }
#         request
#         expect(inventory.reload.amount).to eq 10
#         requested get: 200
#         expect(inventory.reload.amount).to eq 10
#       end
#     end
#
#     context 'when returning a record which type is get' do
#       it 'works' do
#         req_to :create#, with: { app_type: 'get' }
#         expect(inventory.reload.amount).to eq 8
#         request
#         expect(inventory.reload.amount).to eq 10
#         requested get: 200
#         expect(inventory.reload.amount).to eq 10
#       end
#     end
#   end
#
#   # api :approve, :post, '/api/v1/records/approve', '确认审批（当前版本未做审批功能）' do
#   #   let(:params) { { ids: 'array' } }
#   # end
# end
