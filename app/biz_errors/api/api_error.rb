ERROR_BEGIN          = 700
ERROR_CUD            = 600
ERROR_SEVER_ERROR    = [ 0, 'server error' ].freeze
ERROR_AUTHENTICATION = -1
ERROR_AUTHORIZATION  = -10
ERROR_ACTIVE_RECORD  = -100


class ApiError
  extend BusinessError

  class << self
    def authentication
      code ERROR_AUTHENTICATION, :dec
      mattr_reader :invalid_token,      'invalid token'
    end

    def authorization
      code ERROR_AUTHORIZATION, :dec
      mattr_reader :role_error,         'role verification failed'
      mattr_reader :permission_error,   'insufficient permission'
    end

    def active_record
      set_for :are, ERROR_ACTIVE_RECORD, :dec # ar error 太多， 使之不生成 doc
      mattr_reader :record_invalid,     'data validation failed'
      mattr_reader :not_saved,          'failed to save the record'
      mattr_reader :not_found,          ''
      mattr_reader :not_destroyed,      'destroy failed'
      mattr_reader :not_unique,         'duplicate data'
      mattr_reader :invalid_foreignkey, 'not found'
      mattr_reader :not_null,           'something should be not null'
      mattr_reader :value_too_long,     'data so large'
      mattr_reader :range_error,        'out of range'
    end
  end

  authentication
  authorization
  active_record

  set_for_pub
  mattr_reader :invalid_param, 'parameter validation failed', 400
end

ACTIVE_RECORD_ERRORS_MAPPING = {
    # Raised by `save!` and `create!` when the record is invalid.
        record_invalid: ::ActiveRecord::RecordInvalid,
    # Raised by `save!` and `create!` when a record is invalid and can not be saved.
             not_saved: ::ActiveRecord::RecordNotSaved,
    # Raised when Active Record cannot find a record by given id or set of ids.
             not_found: ::ActiveRecord::RecordNotFound,
    # Raised when a call to `destroy!` would return false.
         not_destroyed: ::ActiveRecord::RecordNotDestroyed,
    # Raised when a record cannot be inserted because it would violate a uniqueness constraint.
            not_unique: ::ActiveRecord::RecordNotUnique,
    # Raised when a record cannot be inserted or updated because it references a non-existent record.
    invalid_foreignkey: ::ActiveRecord::InvalidForeignKey,
    # Raised when a record cannot be inserted or updated because it would violate a not null constraint.
              not_null: ::ActiveRecord::NotNullViolation,
    # Raised when a record cannot be inserted or updated because a value too long for a column type.
    #     value_too_long: ::ActiveRecord::ValueTooLong,
    # Raised when values that executed are out of range.
           range_error: ::ActiveRecord::RangeError
}.freeze
