module Error::Concerns::Failed
  def self.included(base)
    base.class_eval do
      define_px :create_failed
      define_px :update_failed
      define_px :destroy_failed
    end
  end
end
