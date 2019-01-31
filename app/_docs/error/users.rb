# frozen_string_literal: true

class Error::Users < Error::Api
  code_start_at 200

  include Error::Concerns::Failed
  
  group :create do
    mattr_reader :record_invalid, 'invalid info'
    mattr_reader :not_null,       'invalid info'
    mattr_reader :not_unique,     'repeated info'
  end

  group :login do
    mattr_reader :login_failed, ''
    alias_attribute :not_found, :login_failed # FIXME
  end
end
