class Api::V1::UsersDoc < ApiDoc
  api :index, 'GET list of users', builder: :index, use: ['Token', :page, :rows] do
  end


  api :show, 'GET the specified user', builder: :show, use: id_and_token


  api :show_via_name, 'GET the specified user by name', builder: :show, use: token do
    path! :name, String, desc: 'user name'
  end


  api :login, 'POST user login', builder: :success_or_not, skip: token do
    form! data: {
            :name! => String,
        :password! => String
    }
  end


  api :create, 'POST user register', builder: :success_or_not, skip: token do
    form! data: {
                         name!: String,
                     password!: String,
        password_confirmation!: String,
                         email: String,
                  phone_number: String
    }, pmt: true
  end


  api :update, 'PATCH|PUT update the specified user', builder: :success_or_not, use: id_and_token do
    form! data: {
                         name: String,
                     password: String,
        password_confirmation: String,
                        email: String,
                 phone_number: String
    }, pmt: true
  end


  api :destroy, 'DELETE the specified user', builder: :success_or_not, use: id_and_token


  # /users/:id/roles
  api :roles, 'GET roles of the specified user', use: token do
    path! :id, Integer
  end


  # /users/:id/permissions
  api :permissions, 'GET permissions of the specified user', use: token do
    path! :id, Integer
  end


  # /user/:id/roles/modify
  api :roles_modify, 'POST modify roles to the specified user', builder: :success_or_not, use: token do
    path! :id, Integer
    data  :role_ids!, Array[{ type: Integer, range: { ge: 1 } }], size: 'ge_0'
  end
end
