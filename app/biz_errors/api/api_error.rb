ERROR_BEGIN          = 700
ERROR_CUD            = 600
ERROR_SEVER_ERROR    = [ 0, 'server error' ]
ERROR_AUTHENTICATION = -1
ERROR_AUTHORIZATION  = -10
ERROR_ACTIVE_RECORD  = -100


class ApiError
  extend BusinessError

  class << self
    def authentication
      code ERROR_AUTHENTICATION, :dec
      mattr_reader :invalid_token,    'invalid token'
    end

    def authorization
      code ERROR_AUTHORIZATION, :dec
      mattr_reader :role_error,       'role verification failed'
      mattr_reader :permission_error, 'insufficient permission'
    end

    def active_record
      set_for :are, ERROR_ACTIVE_RECORD, :dec # ar error 太多， 使之不生成 doc
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

ACTIVE_RECORD_ERRORS_MAPPING = {
        record_invalid: ::ActiveRecord::RecordInvalid,
             not_saved: ::ActiveRecord::RecordNotSaved,
             not_found: ::ActiveRecord::RecordNotFound,
         not_destroyed: ::ActiveRecord::RecordNotDestroyed,
            not_unique: ::ActiveRecord::RecordNotUnique,
    invalid_foreignkey: ::ActiveRecord::InvalidForeignKey,
              not_null: ::ActiveRecord::NotNullViolation,
}
