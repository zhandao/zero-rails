require 'rails_helper'
require 'dssl/request'

RSpec.describe 'API V1', 'users', type: :request do
  subject { MultiJson.load(response.body, symbolize_keys: true) }
  let(:data) { subject[:data] }
  path id: 1

  let(:user) { create(:user) }
  before { user }

  permission_mock can?: %i[ manage_user manage_role_permission ]

  let(:create_params) { { email: 'tester@x.yz', phone_number: '13712345678' } }

  desc :create, :post, '/api/v1/users', 'post create a user' do
    let(:params) { create_params }

    it_checks_permission

    it 'works' do
      expect(User.count).to eq 1
      called get: 200
      expect(User.count).to eq 2
    end
  end

  desc :index, :get, '/api/v1/users', 'get list of users', :token_needed do
    let(:params) { { page: 'integer', rows: 'integer' } }

    it_checks_permission
  end

  desc :update, :patch, '/api/v1/users/{id}', 'update the specified user', :token_needed do
    let(:params) { { email: 'string', phone_number: 'string' } }

    it_checks_permission
  end

  desc :destroy, :delete, '/api/v1/users/{id}', 'delete the specified user', :token_needed do
    it_checks_permission
  end

  desc :login, :post, '/api/v1/users/login', 'post user login' do
    let(:params) { { name: user.name, password: user.password } }

    it('works') { called has_key: :token }
    it('raises not found') { called with: { email: 'xx' }, get: UsersError.not_found.code }
  end

  # desc :logout, :post, '/api/v1/users/logout', 'post user log out', :token_needed do
  #   it 'works' do
  #     old_version = user.token_version
  #     called get: 200
  #     expect(user.reload.token_version).to eq old_version + 1
  #   end
  # end

  before_when :with_rp do
    role = create(:role)
    pmt  = create(:permission)
    role.add permission: pmt.name
    create(:role, name: 'test_role')
  end

  let(:roles_modify_params) { { role_ids: [1] } }

  desc :roles_modify, :post, '/api/v1/users/{id}/roles/modify', 'post set roles of the specified user', :token_needed do
    let(:params) { roles_modify_params }

    it_checks_permission

    it 'works', :with_rp do
      expect(user.roles).to eq [ ]
      called get: 200
      expect(user.reload.roles).to have_size 1
      called by: { role_ids: Role.all.ids << 999 }
      expect(user.reload.roles).to have_size Role.count
      called by: { role_ids: [ ] }
      expect(user.reload.roles).to have_size 0
    end
  end

  desc :roles, :get, '/api/v1/users/{id}/roles', 'get roles of the specified user', :token_needed do
    it 'works', :with_rp do
      expect(user.roles).to eq [ ]
      callto! :roles_modify
      called data: [1]
    end
  end

  desc :permissions, :get, '/api/v1/users/{id}/permissions', 'get permissions of the specified user', :token_needed do
    it 'works', :with_rp do
      expect(user.roles).to eq [ ]
      callto! :roles_modify
      called data: [2]
    end
  end
end
