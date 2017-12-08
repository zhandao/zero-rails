module Generators::ModelDocSupport
  module DSL
    def self.included(base)
      base.extend Generators::ModelDocSupport::ClassMethods
      base.include Generators::Rspec::Model
    end
  end

  module ClassMethods
    include Generators::DSL
    include Generators::ModelDocSupport::Helpers

    # fields: { attr_name: [ type, { options }, {} ..]}
    def field name, type, req, options = [ ], options_hash = { }
      options = options.map { |key| { key => true } }.reduce({ }, :merge).merge(options_hash) if options.is_a?(Array)
      info = [type, process_and_returns_options(name, type, req, options)]
      info << { null: false } if req == :req
      fields[name] = info
    end

    TYPE_TO_DEFAULT_VAL.keys.each do |type|
      define_method type do |name, options = [ ], options_hash = { }|
        field name, type, :opt, options, options_hash
      end

      define_method "#{type}!" do |name, options = [ ], options_hash = { }|
        field name, type, :req, options, options_hash
      end
    end

    # render validates, builder_support
    def end_of_attrs
      process_validates

      if builder_rmv.present?
        model_rb_stack.last << <<~BD
          builder_support rmv: %i[ #{builder_rmv.join(' ')} ]
        BD
      end
      model_rb_stack.last << "\n"
    end

    def references to_what
      field to_what, :references, :opt, index: true
    end

    def index *fields
      # TODO
    end

    def belongs_to name, req = :opt, polymorphic: nil
      name = name.to_s.singularize
      options = req == :opt ? { optional: true } : { }
      options[:polymorphic] = true if polymorphic
      field name, :belongs_to, req, options.merge(foreign_key: true)
      model_rb_stack.last << <<~BT
        belongs_to :#{name}#{', ' << pr(options) if options.present?}
      BT
      model_rb_stack.last << "\n"
    end

    def belongs_to! name, polymorphic: nil
      belongs_to name, :req, polymorphic: polymorphic
    end

    %i[ has_one has_many has_many_through has_one_through has_and_belongs_to_many ].each do |relation|
      define_method relation do |name|
        #
        model_rb_stack.last << <<~R
          #{relation} :#{relation['many'] ? name.to_s.pluralize : name.singularize }
        R
        model_rb_stack.last << "\n"
      end
    end

    # through == through_field_name
    def self_joins has_relation, base: nil, through: nil, dependent_destroy: true, optional: true
      through = "sub_#{model_name.underscore}" unless through
      sub_method_name = through.pluralize
      base = "base_#{model_name.underscore}" unless base

      references through
      model_rb_stack.last << <<~SJ
        #{has_relation} :#{sub_method_name}, class_name: '#{model_name}', foreign_key: '#{through}_id'#{', dependent: :destroy' if dependent_destroy}
        belongs_to :#{base}, class_name: '#{model_name}', optional: #{optional.to_s}
      SJ
      model_rb_stack.last << "\n"
    end

    def soft_destroy
      model_rb_stack.last << <<~SD
        acts_as_paranoid
      SD
      model_rb_stack.last << "\n"
      datetime :deleted_at
    end

    def scope name, desc = nil, &block
      describe name.to_s, desc ? "[scope] #{desc}" : '[scope]', &block
      model_rb_stack.last << <<~SCOPE
        scope :#{name}, -> { all }
      SCOPE
      model_rb_stack.last << "\n"
    end

    def class_method name, desc = nil, &block
      describe name.to_s, desc, &block
      # TODO: comment block doc
      model_rb_stack.last << <<~CM
        # #{desc || 'desc'}
        def self.#{name}
          # TODO
        end
      CM
      model_rb_stack.last << "\n"
    end

    def class_methods *names
      names.each { |name| class_method name }
    end

    alias_method :cmethod, :class_method
    alias_method :cmethods, :class_methods

    def instance_method name, desc = nil, &block
      describe name.to_sym, desc, &block
      # TODO: comment block doc
      model_rb_stack.last << <<~IM
        # #{desc || 'desc'}
        def #{name}
          # TODO
        end
      IM
      model_rb_stack.last << "\n"
    end

    def instance_methods *names
      names.each { |name| instance_method name }
    end

    alias_method :imethod, :instance_method
    alias_method :imethods, :instance_methods

    # generate api doc
    def g(path)
      self.doc_version = path
    end
  end
end
