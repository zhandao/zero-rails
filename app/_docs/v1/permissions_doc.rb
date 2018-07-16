class Api::V1::PermissionsDoc < ApiDoc
  api_dry :all do
    auth :Token
  end

  api :index, 'GET permissions list of the specified model', builder: :index do
    query :model, String, dft: '', reg: /\A[A-Z][A-z]*\z/
  end


  api_dry %i[ create update ] do
    form! data: {
        :source => String,
        :remarks => String,
        :model => { type: String, dft: '', reg: /\A[A-Z][A-z]*\z/ }
    }, pmt: true
  end


  api :create, 'POST create a permission', builder: :success_or_not do
    form! data: {
        :name! => { type: String, desc: 'the sign of permission, it must be unique' },
    }, pmt: true
  end


  api :update, 'PATCH|PUT update the specified permission', builder: :success_or_not, use: id do
    form! data: {
        :name => String,
    }, pmt: true
  end


  api :destroy, 'DELETE the specified permission', builder: :success_or_not, use: id do
  end
end
