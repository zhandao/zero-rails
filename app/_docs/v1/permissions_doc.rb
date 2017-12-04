class PermissionsError < V1Error
  include CUDFailed, AuthFailed
end

class Api::V1::PermissionsDoc < ApiDoc
  api :index, 'GET permissions list of the specified model.', builder: :index, use: token do
    query :model, String, dft: 'User', reg: /^[A-Z]/
  end


  api :create, 'POST create a permission.', builder: :success_or_not, use: token do
    form! 'for creating the specified permission', data: {
            :name! => { type: String, desc: 'name of permission' },
        :condition => { type: String, dft: 'true', desc: '暂不必传' },
          :remarks => String
    }
  end


  api :create, 'PATCH update the specified permission.', builder: :success_or_not, use: id_and_token do
    form! 'for updating the specified permission', data: {
             :name => { type: String, desc: 'name of permission' },
        :condition => { type: String, dft: 'true', desc: '暂不必传' },
          :remarks => String
    }
  end


  api :destroy, 'DELETE the specified permission.', builder: :success_or_not, use: id_and_token
end
