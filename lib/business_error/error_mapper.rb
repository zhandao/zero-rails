module BusinessError
  module ErrorMapper
    def self.extended(base)
      base.generate_rule_method RULES
    end

    mattr_accessor :current_rule

    def proc(&proc)
      Proc.new(&proc)
    end

    RULES = {
        exist: {
            if: 'obj.nil? == false',
            do: proc { puts ApiError.send :invalid_param, :info },
            raise: :invalid_param,
            error: ApiError
        },
        not_null: {
            if: 'obj.nil? == false',
            do: proc { puts ApiError.send :invalid_param, :info },
            raise: :invalid_param
        },
    }

    def error!
      the_error = RULES[self.current_rule][:error] || Object.const_get("#{self.name.to_s[0..-7]}") || base_error
      the_error.send(RULES[self.current_rule][:raise])
    end

    def not_null(obj)
      puts "#{obj.name} / #{obj.value}"
      self.current_rule = :not_null
      # error!
      RULES[:exist][:do].call if eval(RULES[:exist][:if])
    end

    def base_error
      @@base_error ||= ZConfig.processor.base_error_class
    end

    def generate_rule_method(rules_hash)
      rules_hash.each_key do |rule|
        define_singleton_method rule do |obj|
          puts rule
          self.current_rule = rule
          RULES[rule][:do].call if eval(RULES[rule][:if])
        end unless respond_to? rule
      end
    end

    def rules(rules_hash)
      RULES.merge! rules_hash
      generate_rule_method rules_hash
    end
  end
end