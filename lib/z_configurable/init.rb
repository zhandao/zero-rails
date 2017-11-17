module ZConfigurable
  module Init
    mattr_accessor :current_config

    def config
      config_var = "@#{self.current_config}_config"
      if instance_variable_get(config_var).nil?
        # TODO: performance testing
        instance_variable_set(config_var, ActiveSupport::InheritableOptions.new(@default))
      end
      instance_variable_get config_var
    end

    def configure(&block)
      config.instance_eval(&block)
    end

    def default(hash = { })
      @default = hash
    end



    # TODO(HA): 名称存在时无法走到这里
    def method_missing(method, *args, &block)
      cattr_accessor method
      define_singleton_method method do
        if @_config.nil? # Config.configure {} will set @_config
          self.current_config = method
          camel_case = method.to_s.match?(/[A-Z]/) ?
                           method.to_s[0].capitalize + method.to_s[1..-1] :
                           method.to_s.camelize
          constant_searched = instance_variable_get("@#{method}_searched")
          current_constant  = instance_variable_get("@#{method}_config")
          unless constant_searched
            constant = scan_constant_tree camel_case
            instance_variable_set("@#{method}_config", constant)
            instance_variable_set("@#{method}_searched", true)
          end
          return current_constant if current_constant.present?

          config = instance_variable_get("@#{current_config}_config")
          config.nil? ? configure(&block) : config
        else
          @_config[method]
        end
      end

      send method
    end

    def respond_to_missing?
      super
    end

    def constant_matcher(super_level, constant_of_super)
      level = super_level.const_get(constant_of_super.to_s)
      level_methods = level.singleton_methods.map(&:to_s)
      level_method_match = level_methods.grep(/config/).first
      return level.send(level_method_match.to_s) if level_method_match.present?
      level_consts = level.constants.map(&:to_s)
      level_const_match = level_consts.grep(/Config/).first
      return level.const_get(level_const_match.to_s) if level_const_match.present?
      nil
    end

    # 自动扫描常量树，寻找是否有 /Config/ 类，或者有无 /config/ 类方法
    # TODO: 广度遍历
    def scan_constant_tree(method)
      begin
        level1 = Object.const_get(method)
        level1_result = self.constant_matcher(Object, method)
        return level1_result if level1_result.present?

        level1.constants.each do |level1_constant|
          level2_result = self.constant_matcher(level1, level1_constant)
          return level2_result if level2_result.present?

          level2 = level1.const_get(level1_constant.to_s)
          level2.constants.each do |level2_constant|
            level3_result = self.constant_matcher(level2, level2_constant)
            return level3_result if level3_result.present?
          end
        end
      rescue NameError
        nil
      end
    end

  end
end
