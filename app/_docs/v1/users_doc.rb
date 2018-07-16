class Api::V1::UsersDoc < ApiDoc
  api_dry %i[ update destroy roles permissions roles_modify ] do
    auth :Token
  end


  api :index, 'GET list of users', builder: :index, use: ['Token', :page, :rows]


  api :show, 'GET the specified user', builder: :show, use: id


  api :show_via_name, 'GET the specified user by name', builder: :show do
    path! :name, String, desc: 'user name'
  end


  api :login, 'POST user login', builder: :success_or_not do
    form! data: {
            :name! => String,
        :password! => String
    }

    response 200, 'success', :json, data: { data: { token: 'jwt token' } }
  end


  api :create, 'POST user register', builder: :show do
    form! data: {
                         name!: String,
                     password!: String,
        password_confirmation!: String,
                         email: String,
                  phone_number: String
    }, pmt: true
  end


  api :update, 'PATCH|PUT update the specified user', builder: :success_or_not, use: id do
    form! data: {
                         name: String,
                     password: String,
        password_confirmation: String,
                        email: String,
                 phone_number: String
    }, pmt: true
  end


  api :destroy, 'DELETE the specified user', builder: :success_or_not, use: id


  # /users/:id/roles
  api :roles, 'GET roles of the specified user' do
    path! :id, Integer
  end


  # /users/:id/permissions
  api :permissions, 'GET permissions of the specified user' do
    path! :id, Integer
  end


  # /user/:id/roles/modify
  api :roles_modify, 'POST modify roles to the specified user', builder: :success_or_not do
    path! :id, Integer
    data  :role_ids!, Array[{ type: Integer, lth: 'ge_1' }], size: 'ge_0'
  end
end
