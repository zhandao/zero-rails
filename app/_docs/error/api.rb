class Error::Api
  extend BusinessError

  # this error definition could be inherited
  mattr_reader :invalid_param, 'parameter validation failed', 0, http: :bad_request

  class << self
    def auth
      code_start_at 10
      # mattr_reader :invalid_token,    'invalid token',            http: :unauthorized
      # mattr_reader :invalid_token,    'unauthorized',  http: :unauthorized
      # mattr_reader :role_error,       'role verification failed', http: :forbidden
      mattr_reader :permission_error, 'insufficient permission',  http: :forbidden
    end

    def active_record
      group :active_record_errors, 20, http: :internal_server_error do
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
  end

  auth
  active_record
end

ACTIVE_RECORD_ERRORS_MAPPING = {
    # Raised by `save!` and `create!` when the record is invalid.
        record_invalid: ::ActiveRecord::RecordInvalid,
    # Raised by `save!` and `create!` when a record is invalid and can not be saved.
    #          not_saved: ::ActiveRecord::RecordNotSaved,
    # Raised when Active Record cannot find a record by given id or set of ids.
             not_found: ::ActiveRecord::RecordNotFound,
    # Raised when a call to `destroy!` would return false.
    #      not_destroyed: ::ActiveRecord::RecordNotDestroyed,
    # Raised when a record cannot be inserted because it would violate a uniqueness constraint.
            not_unique: ::ActiveRecord::RecordNotUnique,
    # Raised when a record cannot be inserted or updated because it references a non-existent record.
    # invalid_foreignkey: ::ActiveRecord::InvalidForeignKey,
    # Raised when a record cannot be inserted or updated because it would violate a not null constraint.
    #           not_null: ::ActiveRecord::NotNullViolation,
    # Raised when a record cannot be inserted or updated because a value too long for a column type.
    #     value_too_long: ::ActiveRecord::ValueTooLong,
    # Raised when values that executed are out of range.
    #        range_error: ::ActiveRecord::RangeError
}.freeze
