class Api::V1::UsersDoc < ApiDoc
  # ctrl_path 'api/v1/users' # Note: auto_gen at lib/auto

  components do
    # schema :UserResp => [ { id: Integer, name: String }, dft: { id: 1, name: 'pet' } ]
  end


  open_api :index, 'GET list of users.', builder: :index, use: ['Token', :page, :rows] do
    # query! :id, Integer, enum: 0..5, length: [1, 2], pattern: /^[0-9]$/, range: { gt:0, le:5 }
    # dft_resp 'users', :json, data: :UserResp
  end


  open_api :show, 'GET the specified user.', builder: :show, use: token do
    query! :id, Integer, range: { ge: 1 }
  end


  open_api :show_via_name, 'GET the specified user by name.', builder: :show, use: token do
    path! :name, String, desc: 'user name'
  end


  open_api :login, 'POST user login.', builder: :success_or_not, skip: token do
    form! 'for user login', data: {
            :name! => { type: String, desc: 'user name' },
        :password! => String,
    }
  end


  open_api :create, 'POST user register', builder: :success_or_not, skip: token do
    form! 'for registering user', data: {
                         name!: String,
                     password!: String,
        password_confirmation!: String,
                         email: String,
                  phone_number: String,
    }
  end


  open_api :update, 'PATCH update the specified User.', builder: :success_or_not, use: id_and_token do
    form! 'for updating the specified user', data: {
                         name: String,
                     password: String,
        password_confirmation: String,
                        email: String,
                 phone_number: String,
    }
  end


  open_api :destroy, 'DELETE the specified User.', builder: :success_or_not, use: id_and_token


  # /users/:id/roles
  open_api :roles, 'GET roles of the specified user', use: token do
    path! :id, Integer, desc: '要查询的 user id'
  end


  # /users/:id/permissions
  open_api :permissions, 'GET permissions of the specified user', use: token do
    path! :id, Integer, desc: '要查询的 user id'
  end


  # /admin/:id/roles/modify
  open_api :roles_modify, 'POST modify roles to the specified user', builder: :success_or_not, use: token do
    path! :id, Integer, desc: 'user id'
    form! 'for modifying roles to the specified user', data: {
        :role_ids! => { type: Array[{ type: Integer, range: { ge: 1 } }], size: 'ge_1' }
    }
  end
end
