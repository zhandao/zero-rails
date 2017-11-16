class UsersError < V1Error
  set_for :create
  mattr_reader :create_error, 'invalid info',    600

  set_for :login
  mattr_reader :login_failed,  '', 601
  alias_attribute :not_found, :login_failed
end
