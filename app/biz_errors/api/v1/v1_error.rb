class V1Error < ApiError

end

module CUDFailed
  def self.included(base)
    base.class_eval do
      active_record

      set_global :prefix, 600
      mattr_reader :create_failed,  ''
      mattr_reader :update_failed,  ''
      mattr_reader :destroy_failed, ''
      unset
    end
  end
end

module AuthFailed
  def self.included(base)
    base.class_eval do
      authentication
      authorization
    end
  end
end
