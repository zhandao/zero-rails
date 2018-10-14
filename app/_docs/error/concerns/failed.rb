module Error::Concerns::Failed
  def self.included(base)
    base.class_eval do
      code_start_at 600
      define_px :create_failed
      define_px :update_failed
      define_px :destroy_failed
      @code = nil
    end
  end
end
