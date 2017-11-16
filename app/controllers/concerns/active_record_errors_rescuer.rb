module ActiveRecordErrorsRescuer
  def self.included(base)
    base.class_eval do
      before_action do
        @status = true
      end

      rescue_from ::ActiveRecord::ActiveRecordError do
        @status = false
        @error_info = Rails.env.production? ? [ 0, 'Internal Server Error' ] : [ -100, e.message ]
        render "api/v1/#{controller_name}/#{action_name}"
      end

      if const_defined? "#{controller_name.camelize}Error"
        ar_errors = {
                record_invalid: ::ActiveRecord::RecordInvalid,
                     not_saved: ::ActiveRecord::RecordNotSaved,
                     not_found: ::ActiveRecord::RecordNotFound,
                 not_destroyed: ::ActiveRecord::RecordNotDestroyed,
                    not_unique: ::ActiveRecord::RecordNotUnique,
            invalid_foreignkey: ::ActiveRecord::InvalidForeignKey,
                      not_null: ::ActiveRecord::NotNullViolation,
        }

        error_class = Object.const_get "#{controller_name.camelize}Error"
        (error_class.errors.values.flatten & ar_errors.keys).each do |error_name|
          rescue_from ar_errors[error_name] do |e|
            @status = false
            @error_info = Rails.env.production? ? error_class.send(error_name, :info).values : [ -100, e.message ]
            render "api/v1/#{controller_name}/#{action_name}"
          end
        end
      end
    end
  end
end
