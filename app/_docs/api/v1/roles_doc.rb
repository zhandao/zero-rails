class Api::V1::RolesDoc < ApiDoc
  api_dry :all do
    auth :Authorization
  end


  api :index, 'GET roles list of the specified model', builder: :index do
    query :model, String, dft: '', reg: /\A[A-Z][A-z]*\z/
  end


  api :show, 'GET the specified role.', builder: :show, use: id


  api_dry %i[ create update ] do
    form! data: {
        :remarks => String,
        :model => { type: String, dft: '', reg: /\A[A-Z][A-z]*\z/ }
    }, pmt: true
  end


  api :create, 'POST create a role', builder: :success_or_not do
    form! data: {
        :name! => { type: String, desc: 'name of role' },
    }, pmt: true
  end


  api :update, 'PATCH|PUT update the specified role', builder: :success_or_not, use: id do
    form! data: {
        :name => String,
    }, pmt: true
  end


  api :destroy, 'DELETE the specified role', builder: :success_or_not, use: id


  # /roles/:id/permissions
  api :permissions, 'GET permissions of specified role' do
    path! :id, Integer
  end


  # /roles/:id/permissions/modify
  api :permissions_modify, 'POST modify permissions to the specified roles', builder: :success_or_not do
    path! :id, Integer
    data :permission_ids!, Array[{ type: Integer, lth: 'ge_1' }], size: 'ge_0'
  end
end
