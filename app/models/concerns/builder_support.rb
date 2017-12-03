module BuilderSupport
  def self.included(base)
    base.include AssocUnscope
    base.class_eval do
      def self.builder_support rmv: [ ], add: [ ]
        extend ClassMethods
        delegate :show_attrs, :flatten_attrs, to: self
        include InstanceMethods

        builder_rmv *rmv
        # %i[ a, b, c d ]
        # %i[ unscoped: a b, flatten: c d ]
        add.map { |item| item[','] ? [item.to_s.delete(','), ','] : item }
           .flatten.map(&:to_sym).split(:',').each do |attrs|
          builder_add *attrs
        end
      end
    end
  end

  module InstanceMethods
    def to_builder(rmv: [ ], add: [ ], merge: { })
      Jbuilder.new do |json|
        json.(self, *self.show_attrs(rmv: rmv, add: add))
        self.flatten_attrs(rmv: rmv, add: add).each do |flatten_attr|
          json.merge! self.send(flatten_attr)
        end
        instance_exec(json, &json_addition)
        json.merge! merge
      end.attributes!
    end

    def json_addition
      proc { }
    end
  end

  module ClassMethods
    # FIXME: 很奇怪的 scope 影响，尽量用转成 arr 的 to_bd 而不是直接调
    def to_builder(rmv: [ ], add: [ ], merge: { })
      all.to_a.to_builder(rmv: rmv, add: add, merge: merge)
    end

    def builder_rmv *attrs
      (@builder_rmv ||= [ ]).concat attrs
    end

    def builder_add *attrs, &block
      define_method attrs.first do
        instance_eval(&block)
      end if block_given?

      if attrs[1].is_a?(Hash)
        builder_add_with_when attrs
      elsif attrs.delete(:flatten)
        (@flatten_attrs ||= [ ]).concat attrs
      else
        # %i[ unscoped: a b ]
        is_unscoped = attrs.delete(:unscoped) || attrs.delete(:'unscoped:')
        (@builder_add ||= [ ]).concat attrs
        generate_assoc_info_method attrs, is_unscoped
      end
    end

    def builder_map settings = { }
      settings.each do |field_name, alias_key|
        builder_rmv field_name
        builder_add alias_key
        define_method alias_key do
          send field_name
        end
      end
    end

    def show_attrs(rmv: [ ], add: [ ])
      show_attrs = self.column_names.map(&:to_sym) \
                       - (@builder_rmv || [ ]) \
                       + (@builder_add || [ ])

      @builder_add_later&.each do |attr, status_or_block|
        if status_or_block.is_a? Symbol
          show_attrs << attr if instance_variable_get("@#{status_or_block}")
          # instance_variable_set("@#{status_or_block}", false)
        elsif instance_eval &status_or_block
          show_attrs << attr
        end
      end

      show_attrs - rmv + add
    end

    def flatten_attrs(rmv: [ ], add: [ ])
      (@flatten_attrs ||= [ ]) - rmv + add
    end

    def builder_add_with_when(args)
      (@builder_add_later ||= { })[args.first] = args[1][:when]
      # 生成 when 设置的同名函数
      # 用以设置状态
      define_singleton_method args[1][:when] do
        # TODO: 想一个不用在视图层重新置非的方案
        instance_variable_set("@#{args[1][:when]}", true)
        all
      end if args[1][:when].is_a?(Symbol)

      generate_assoc_info_method args.first, false
    end

    def generate_assoc_info_method(attrs, is_unscoped)
      # 匹配关联模型 `name_info` 形式的 attr，并自动生成该方法
      # 方法调用模型的 to_builder 方法并取得最终渲染结果
      # unscoped 主要是为了支持去除软删除的默认 scope
      Array(attrs).each do |attr|
        next unless attr.to_s.match?(/_info/)
        assoc_method = attr.to_s.gsub('_info', '')
        next unless new.respond_to?(assoc_method)

        define_method attr do
          send(assoc_method)&.to_builder || nil
        end

        assoc_unscope assoc_method if is_unscoped
        assoc_model = assoc_method.to_s.singularize
        builder_rmv "#{assoc_model}_id".to_sym
      end
    end
  end
end
