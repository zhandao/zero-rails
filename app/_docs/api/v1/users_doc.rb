class Api::V1::UsersDoc < ApiDoc
  api_dry %i[ index update destroy roles permissions roles_modify ] do
    auth :Authorization
  end

  api :index, 'GET list of users', builder: :index, use: [:page, :rows]

  api :show, 'GET the specified user', builder: :show, use: id

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
                         name!: String,
                     password!: String,
        password_confirmation!: String,
                         email: String,
                  phone_number: String
    }, pmt: true
  end

  api :update, 'PATCH|PUT update the specified user', use: id do
    form! data: {
                         name: String,
                     password: String,
        password_confirmation: String,
                        email: String,
                 phone_number: String
    }, pmt: true
  end

  api :destroy, 'DELETE the specified user', use: id
end
