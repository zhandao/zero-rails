class ApiError
  extend BusinessError

  class << self
    def authentication
      mattr_reader :invalid_token,    'invalid token', -1
    end

    def authorization
      code -10, :dec
      mattr_reader :role_error,       'role verification failed'
      mattr_reader :permission_error, 'insufficient permission'
    end

    def active_record
      set_for :are, -100, :dec # ar error 太多， 使之不生成 doc
      mattr_reader :not_saved,        'failed to save the record'
      mattr_reader :not_found,        'record not found'
    end
  end

  authentication
  authorization
  active_record

  set_for_pub
  mattr_reader :invalid_param, 'parameter validation failed', 400
end
