require 'rails_helper'
require 'dssl/request'

RSpec.describe 'API V1', 'roles', type: :request do
  happy_spec
  path id: 1

  let(:user) { create(:user) }
  before { user }

  permission_mock can?: %i[ manage_role_permission ]

  let(:create_params) { { name: 'string', model: 'User' } }

  api :create, :post, '/api/v1/roles', 'post create a role', :token_needed do
    let(:params) { create_params }

    it_checks_permission
  end

  api :index, :get, '/api/v1/roles', 'get list of roles of the specified model', :token_needed do
    let(:params) { { model: 'string' } }

    it_checks_permission
  end

  api :show, :get, '/api/v1/roles/{id}', 'get the specified role', :token_needed do
    it_checks_permission
  end

  api :update, :patch, '/api/v1/roles/{id}', 'update the specified role', :token_needed do
    let(:params) { { name: 'integer', model: 'User' } }

    it_checks_permission
  end

  api :destroy, :delete, '/api/v1/roles/{id}', 'delete the specified role', :token_needed do
    it_checks_permission
  end

  api :permissions, :get, '/api/v1/roles/{id}/permissions', 'get permissions of the specified role', :token_needed do
    it_checks_permission
  end

  api :permissions_modify, :post, '/api/v1/roles/{id}/permissions/modify', 'post set permissions of the specified role', :token_needed do
    let(:params) { { permission_ids: [1] } }

    it_checks_permission
  end
end
