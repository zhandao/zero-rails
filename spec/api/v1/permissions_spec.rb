require 'rails_helper'
require 'dssl/request'

RSpec.describe 'API V1', 'permissions', type: :request do
  subject { MultiJson.load(response.body, symbolize_keys: true) }
  let(:data) { subject[:data] }
  path id: 1

  let(:user) { create(:user) }
  before { user }

  permission_mock can?: %i[ manage_role_permission ]

  let(:create_params) { { remarks: 'string', path: 'string', icon: 'string', base_permission_id: 'integer', name: 'string', pm_type: 'string' } }

  desc :create, :post, '/api/v1/permissions', 'post create a permission', :token_needed do
    let(:params) { create_params }

    it_checks_permission
  end

  desc :index, :get, '/api/v1/permissions', 'get list of permissions of the specified model', :token_needed do
    let(:params) { { model: 'string', view: 'string' } }

    it_checks_permission
  end

  desc :update, :patch, '/api/v1/permissions/{id}', 'update the specified permission', :token_needed do
    let(:params) { { remarks: 'integer', path: 'string', icon: 'string', base_permission_id: 'string', name: 'integer', pm_type: 'string' } }

    it_checks_permission
  end

  desc :destroy, :delete, '/api/v1/permissions/{id}', 'delete the specified permission.', :token_needed do
    it_checks_permission
  end
end
