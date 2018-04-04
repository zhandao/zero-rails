class UsersError < V1Error
  set_for :create, 700
  mattr_reader :record_invalid, 'invalid info'
  mattr_reader :not_null,       'invalid info'
  mattr_reader :not_unique,     'repeated info'

  set_for :login, 800
  mattr_reader :login_failed, ''
  alias_attribute :not_found, :login_failed # FIXME
end
