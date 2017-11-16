module Zero
  class ParamsAgent < BasicObject
    mattr_accessor :params
    # TODO(FIX): 如果存在同名方法则无法走到这里
    def self.method_missing(request_key, *arguments, &block)
      define_singleton_method(request_key.to_sym) do
        # params[request_key.to_sym]
        params[params.keys.keep_if { |key| key.match? request_key.to_s }.first]
      end
      params[params.keys.keep_if { |key| key.match? request_key.to_s }.first]
    end

    # def self.respond_to_missing?
    #   super
    # end
  end
end
