require 'rails_helper'
require 'dssl/request'

RSpec.describe 'API V1', 'users', type: :request do
  subject { MultiJson.load(response.body, symbolize_keys: true) }
  let(:data) { subject[:data] }
  path id: 1

  permission_mock can?: %i[ manage_user manage_role_permission ]

  let(:create_params) { { name: 'tester', password: 'test', password_confirmation: 'test' } }

  api :create, :post, '/api/v1/users', 'post create a user' do
    let(:params) { create_params }

    it 'works' do
      expect(User.count).to eq 0
      requested get: 200
      expect(User.count).to eq 1
    end
  end

  api :index, :get, '/api/v1/users', 'get list of users' do
    let(:params) { { page: 'integer', rows: 'integer' } }
  end

  api :update, :patch, '/api/v1/users/{id}', 'update the specified user' do
    let(:params) { { email: 'string', phone_number: 'string' } }
  end

  api :destroy, :delete, '/api/v1/users/{id}', 'delete the specified user' do
  end

  api :login, :post, '/api/v1/users/login', 'post user login' do
    let(:params) { { name: 'tester', password: 'test' } }
    before { req_to! :create }

    it('works') { requested has_key: :token }
    it('raises not found') { requested with: { name: 'xx' }, get: UsersError.login_failed.code }
  end

  # api :logout, :post, '/api/v1/users/logout', 'post user log out', :token_needed do
  #   it 'works' do
  #     old_version = user.token_version
  #     requested get: 200
  #     expect(user.reload.token_version).to eq old_version + 1
  #   end
  # end

  let(:user) { create(:user) }

  before_when :with_rp do
    user
    role = create(:role)
    pmt  = create(:permission)
    role.add permission: pmt.name
    create(:role, name: 'test_role')
  end

  let(:roles_modify_params) { { role_ids: [1] } }

  api :roles_modify, :post, '/api/v1/users/{id}/roles/modify', 'post set roles of the specified user', :token_needed do
    let(:params) { roles_modify_params }

    it_checks_permission

    it 'works', :with_rp do
      expect(user.roles).to eq [ ]
      requested get: 200
      expect(user.reload.roles).to have_size 1
      request by: { role_ids: Role.all.ids << 999 }
      expect(user.reload.roles).to have_size Role.count
      request by: { role_ids: [0] } # FIXME: pass [] will be convert to ['']??
      expect(user.reload.roles).to have_size 0
    end
  end

  api :roles, :get, '/api/v1/users/{id}/roles', 'get roles of the specified user', :token_needed do
    it_checks_permission

    it 'works', :with_rp do
      expect(user.roles).to eq [ ]
      req_to! :roles_modify
      request data: ['role']
    end
  end

  # api :permissions, :get, '/api/v1/users/{id}/permissions', 'get permissions of the specified user', :token_needed do
  #   it_checks_permission
  #
  #   it 'works', :with_rp do
  #     expect(user.roles).to eq [ ]
  #     req_to! :roles_modify
  #     requested data: [2]
  #   end
  # end
end
