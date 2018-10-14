class Error::Users < Error::Api
  include Error::Concerns::Failed
  
  group :create, 700 do
    mattr_reader :record_invalid, 'invalid info'
    mattr_reader :not_null,       'invalid info'
    mattr_reader :not_unique,     'repeated info'
  end

  group :login, 800 do
    mattr_reader :login_failed, ''
    alias_attribute :not_found, :login_failed # FIXME
  end
end
