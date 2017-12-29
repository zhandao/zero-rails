class Api::V1::PermissionsDoc < ApiDoc
  api :index, 'GET permissions list of the specified model.', builder: :index, use: token do
    query :model, String, dft: 'User', reg: /^[A-Z]/
  end


  api :create, 'POST create a permission.', builder: :success_or_not, use: token do
    form! data: {
            :name! => { type: String, desc: 'name of permission' },
        :condition => { type: String, dft: 'true', desc: '暂不必传' },
          :remarks => String
    }, pmt: true
  end


  api :update, 'PATCH update the specified permission.', builder: :success_or_not, use: id_and_token do
    form! data: {
             :name => { type: String, desc: 'name of permission' },
        :condition => { type: String, dft: 'true', desc: '暂不必传' },
          :remarks => String
    }, pmt: true
  end


  api :destroy, 'DELETE the specified permission.', builder: :success_or_not, use: id_and_token
end
