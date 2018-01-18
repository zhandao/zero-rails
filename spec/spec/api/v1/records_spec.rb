# require 'rails_helper'
# require 'dssl/request'
#
# RSpec.describe 'API V1', 'records', type: :request do
#   let(:resp) { MultiJson.load(response.body, symbolize_keys: true) }
#   subject { resp }
#
#   before do
#     allow_any_instance_of(Api::V1::RecordsController).to receive(:info_from_fingerprint).and_return(1000)
#     allow_any_instance_of(Api::V1::RecordsController).to receive(:info_from_sec_depart).and_return(
#         app_name: 'tom', dep: 'internet'
#     )
#     create(:floor)
#     create(:floor, code: '2', addr: '2F')
#   end
#
#   let(:create_params) { { floor_code: '2', fingerprint: 'string', app_type: 'get', data: [{ good_id: 1, app_count: 2, total_prices: 2 }] } }
#   let(:inventory) { Inventory.find_by(floor_id: 2, good_id: 1) }
#
#   desc :create, :post, '/api/v1/records', '创建一条记录，当人们提交领用需求清单时请求该接口' do
#     let(:params) { create_params }
#     before { prepare_goods inv: 10 }
#
#     it 'works' do
#       called get: 200
#       expect(Record.last).to have_attributes(floor_id: 2, good_id: 1, app_type: 'get', app_id: 1000, app_name: 'tom')
#       expect(inventory.amount).to eq 8
#     end
#
#     context 'when inv is not enough' do
#       it 'transaction abort' do
#         called with: { data: [{ good_id: 1, app_count: 2, total_prices: 2 }, { good_id: 1, app_count: 10, total_prices: 10 }] },
#                get: ERROR_CUD
#         expect(Record.count).to eq 0
#         expect(inventory.amount).to eq 10
#       end
#     end
#   end
#
#   desc :index, :get, '/api/v1/records', 'get list of records (员工领借记录)' do
#     let(:params) { { floor_code: '2', search_type: 'name', value: 'string', export: false } }
#     before do
#       prepare_goods name: ('aaa'..'aae').to_a
#       callto :create, with: { data: [{ good_id: 1 }, { good_id: 2 }, { good_id: 5 }].map { |h| h.merge!(app_count: 1, total_prices: 1) } }
#     end
#
#     context 'search by good name' do
#       it { called with: { value: 'aa' }, has_size: 3 }
#       it { called with: { value: 'ac' }, has_size: 0 }
#     end
#
#     context 'search by applicant info' do
#       it { called with: { search_type: 'fingerprint' }, has_size: 3 }
#     end
#   end
#
#   # desc :take, :post, '/api/v1/records/take', '确认员工已到前台领取物品（当前版本不需调用）' do
#   #   let(:params) { { fingerprint: 'string' } }
#   # end
#
#   desc :return, :post, '/api/v1/records/return', '确认员工已到前台归还物品' do
#     let(:params) { { ids: [1], app_id: 1000 } }
#     before { prepare_goods inv: 10 }
#
#     it 'works' do
#       callto :create, with: { app_type: 'borrow' }
#       expect(inventory.amount).to eq 8
#       called get: 200
#       expect(inventory.reload.amount).to eq 10
#       expect(Record.last.return_at).not_to be_nil
#     end
#
#     context 'when returning a returned record' do
#       it 'does nothing' do
#         callto :create, with: { app_type: 'borrow' }
#         called
#         expect(inventory.reload.amount).to eq 10
#         called get: 200
#         expect(inventory.reload.amount).to eq 10
#       end
#     end
#
#     context 'when returning a record which type is get' do
#       it 'works' do
#         callto :create#, with: { app_type: 'get' }
#         expect(inventory.reload.amount).to eq 8
#         called
#         expect(inventory.reload.amount).to eq 10
#         called get: 200
#         expect(inventory.reload.amount).to eq 10
#       end
#     end
#   end
#
#   # desc :approve, :post, '/api/v1/records/approve', '确认审批（当前版本未做审批功能）' do
#   #   let(:params) { { ids: 'array' } }
#   # end
# end
