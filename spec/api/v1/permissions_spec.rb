require 'rails_helper'
require 'dssl/request'

RSpec.describe 'API V1', 'permissions', type: :request do
  happy_spec
  path id: 1

  let(:user) { create(:user) }
  before { user }

  permission_mock can?: %i[ manage_role_permission ]

  let(:create_params) { { name: 'permission', model: 'User', source: 'string' } }

  api :create, :post, '/api/v1/permissions', 'post create a permission', :token_needed do
    let(:params) { create_params }

    it_checks_permission
  end

  api :index, :get, '/api/v1/permissions', 'get list of permissions of the specified model', :token_needed do
    let(:params) { { model: 'User' } }

    it_checks_permission
  end

  api :update, :patch, '/api/v1/permissions/{id}', 'update the specified permission', :token_needed do
    let(:params) { { name: 'permission', model: 'User', source: 'string' } }

    it_checks_permission
  end

  api :destroy, :delete, '/api/v1/permissions/{id}', 'delete the specified permission', :token_needed do
    it_checks_permission
  end
end
