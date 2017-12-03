module AssocUnscope
  def self.included(base)
    base.class_eval do
      extend ClassMethods
    end
  end

  module ClassMethods
    def assoc_unscope *assoc_methods
      assoc_methods.each do |assoc_method|
        next if (@assoc_unscoped ||= [ ]).include?(assoc_method)
        @assoc_unscoped << assoc_method
        define_method assoc_method do
          assoc_method.to_s.singularize.camelize.constantize.unscoped { super() }
        end
      end
    end
  end
end
