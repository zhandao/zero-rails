class Api::V1::PermissionsDoc < ApiDoc

  open_api :index, 'GET list of Permissions of specified model', builder: :index, use: token do
    query :model, String, dft: 'User', reg: /^[A-Z]/
  end


  open_api :create, 'POST create a Permission', builder: :success_or_not, use: token do
    form! 'for creating a permission', data: {
            :name! => { type: String, desc: 'name of permission' },
        :condition => { type: String, dft: 'true', desc: '暂不必传' },
          :remarks => String
    }
  end


  open_api :create, 'PATCH update a Permission', builder: :success_or_not, use: id_and_token do
    form! 'for updating a permission', data: {
             :name => { type: String, desc: 'name of permission' },
        :condition => { type: String, dft: 'true', desc: '暂不必传' },
          :remarks => String
    }
  end


  open_api :destroy, 'DELETE a Permission.', builder: :success_or_not, use: id_and_token
end
