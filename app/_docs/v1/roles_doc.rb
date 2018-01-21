class Api::V1::RolesDoc < ApiDoc
  api :index, 'GET roles list of the specified model', builder: :index, use: token do
    query :model, String, dft: 'User', reg: /^[A-Z]/
  end


  api :show, 'GET the specified role.', builder: :show, use: id_and_token


  api :create, 'POST create a role', builder: :success_or_not, use: token do
    form! data: {
            :name! => { type: String, desc: 'name of role' },
          :remarks => String
    }, pmt: true
  end

  api :destroy, 'DELETE the specified role.', builder: :success_or_not, use: id_and_token

  # /roles/:id/permissions
  api :permissions, 'GET permissions of specified role', use: token do
    path! :id, Integer, desc: '要查询的 role id'
  end


  # /roles/:id/permissions/modify
  api :permissions_modify, 'POST modify permissions to the specified role and then save to db',
           builder: :success_or_not, use: token do
    path! :id, Integer, desc: 'role id'
    form! data: {
        :permission_ids! => { type: Array[{ type: Integer, range: { ge: 1 } }], size: 'ge_1' }
    }
  end
end
