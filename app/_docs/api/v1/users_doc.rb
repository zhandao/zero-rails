# frozen_string_literal: true

class Api::V1::UsersDoc < ApiDoc
  api_dry %i[ index update destroy roles permissions roles_modify ] do
    auth :Authorization
  end

  api :index, 'GET list of users', builder: :index do
    dry only: [:page, :rows]
  end

  api :show, 'GET the specified user', builder: :show do
    dry only: :id
  end

  api :show_via_name, 'GET the specified user by name', builder: :show do
    path! :name, String, desc: 'user name'
  end

  api :login, 'POST user login' do
    form! data: {
            :name! => String,
        :password! => String
    }

    response 0, 'success', :json, data: { data: { token: 'jwt token' } }
  end

  api :create, 'POST user register' do
    form! data: {
                         name!: { type: String, permit: true },
                     password!: { type: String, permit: true },
        password_confirmation!: { type: String, permit: true },
                         email: { type: String, permit: true },
                  phone_number: { type: String, permit: true }
    }
  end

  api :update, 'PATCH|PUT update the specified user' do
    dry only: :id
    form! data: {
                         name: { type: String, permit: true },
                     password: { type: String, permit: true },
        password_confirmation: { type: String, permit: true },
                        email: { type: String, permit: true },
                 phone_number: { type: String, permit: true }
    }
  end

  api :destroy, 'DELETE the specified user' do
    dry only: :id
  end
end
