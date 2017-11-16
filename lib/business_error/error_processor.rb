module BusinessError
  module ErrorProcessor

    def self.included(base)
      base.extend ClassMethods
    end

    # 名字有待商榷
    # 传参形式:
    #   1 is :not_null
    #   2 is %i[not_null not_blank exist]
    def is(status)
      controller_mapper = Object.const_get(controller_path.camelize.concat('ErrorMapper')) rescue nil
      if status.is_a? Symbol
        if controller_mapper.present?
          controller_mapper.send(status, @the_obj_under_check)
        else
          base_mapper.send(status, @the_obj_under_check)
        end
      elsif status.is_a? Array
        # TODO
      end
    end

    private

    def take_var(obj_name, val = NoPass)
      block_given? ? yield(obj_name) : val
    end

    def make_sure(obj_name, what = {})
      @the_obj_under_check =
          if obj_name.is_a? Symbol
            Obj.new obj_name, take_var(obj_name, &@_take_variable_proc)
          elsif obj_name.is_a? Array
            Obj.new obj_name[0], obj_name[1]
          end

      what.each_key do |action|
        send(action, what[action])
      end

      # base_error.invalid_param if x==123
      self
    end

    # 传参形式:
    #   1 make_sure_all :name, [obj1, obj2, ...]
    #   2 make_sure_all name1: obj1, name2: obj2, ...
    #   3 make_sure_all :name1, :name2, :name3 ...
    # TODO
    def make_sure_all(*args)
      return if args.empty?
      if args.size.eql?(1) && args[0].is_a?(Hash)
        # case 2

      elsif args[1].is_a? Symbol
        # case 3
      elsif args[1].is_a? Array
        # case 1
      end
    end

    def base_mapper
      @base_mapper ||= ZConfig.processor.base_mapper_class
    end

    def processor(binding)
      @_take_variable_proc = Proc.new do |who|
        who = who.to_s
        if who['@']
          instance_variable_get(who)
        else
          binding.local_variable_get(who)
        end
      end
    end

    class NoPass; end

    class Obj
      attr_accessor :name, :value
      def initialize(name, value)
        @name = name
        @value = value
      end
    end


    module ClassMethods
      def generate_make_sure(*statuses)
        statuses.each do |status|
          define_method "make_sure_#{status}" do |obj_name|
            make_sure obj_name, {is: status}
          end
          private "make_sure_#{status}".to_sym
        end
      end
    end
  end
end