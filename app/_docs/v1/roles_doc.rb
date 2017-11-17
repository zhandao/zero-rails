class Api::V1::RolesDoc < ApiDoc

  open_api :index, 'Get list of Roles of specified model', builder: :index, use: token do
    query :model, String, dft: 'User', reg: /^[A-Z]/
  end


  open_api :show, 'Show a Role.', builder: :show, use: id_and_token


  open_api :create, 'POST create a Role', builder: :success_or_not, use: token do
    form! 'for creating a role', data: {
            :name! => { type: String, desc: 'name of role' },
        :condition => { type: String, dft: 'true', desc: '暂不必传' },
          :remarks => String
    }
  end

  open_api :destroy, 'Delete a Role.', builder: :success_or_not, use: id_and_token

  # /roles/:id/permissions
  open_api :permissions, 'GET Permissions of specified role', use: token do
    path! :id, Integer, desc: '要查询的 role id'
  end


  # /roles/:id/permissions/modify
  open_api :permissions_modify, 'POST modify Permissions to specified role',
           builder: :success_or_not, use: token do
    path! :id, Integer, desc: 'role id'
    form! 'for modifying permissions to role', data: {
        :permission_ids! => { type: Array[{ type: Integer, range: { ge: 1 } }], size: 'ge_1' }
    }
  end
end
