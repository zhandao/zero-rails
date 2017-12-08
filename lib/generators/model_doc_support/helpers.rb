module Generators::ModelDocSupport
  module Helpers
    include Generators::Helpers

    def inherited(base)
      super
      base.class_eval do
        cattr_accessor :model_name, :model_rb_stack, :migration_rb_stack, :fbot_rb_stack, :migration_indexes, :builder_rmv
        cattr_accessor :fields, :scopes, :imethods, :cmethods, :to_single_validates, :version, :doc_version

        self.model_name = name.sub('Mdoc', '')
        self.model_rb_stack = [ '' ]
        self.migration_rb_stack = [ '' ]
        self.fbot_rb_stack = [ '' ]
        self.fields = { }
        self.migration_indexes = [ ]
        self.builder_rmv = [ ]
        self.to_single_validates = { }

        self.path = "models/#{model_name.underscore}"
      end
    end

    TYPE_TO_DEFAULT_VAL = {
        string: "'string'",
        boolean: true,
        integer: 1,
        decimal: 1.0,
        float: 1.0,
        text: "'text'",
        binary: 1,
        date: '{ Date.today }',
        datetime: '{ DateTime.now }',
        time: '{ Time.current }',
        timestamp: '{ Time.current.to_i }'
    }.freeze

    def process_and_returns_options(name, type, req, options)
      builder_rmv << name if options.delete(:show)
      options = key_alias options, {
          [:unique, :uniq] =>     :uniqueness,
          [:uniqueness, :uniq] => :unique,
          in:  :inclusion,
          ex:  :exclusion,
          lth: :length,
          num: :numericality,
          should_blank: :presence,
          not_blank:    :absence
      }
      options[:numericality] = key_alias options[:numericality], {
          int: :only_integer, gt: :greater_than, gte: :greater_than_or_equal_to,
          eq: :equal_to,      lt: :less_than,    lte: :less_than_or_equal_to
      } if options.key?(:numericality)

      options
    end

    def allow_nil?(names)
      Array(names).each { |name| return false if _fields[name][:null] == false }
      true
    end

    def _fields
      Hash[fields.map { |name, info| [name, info[1..-1].reduce({ }, :merge)] }]
    end

    def process_validates
      %i[ null presence absence uniqueness ].each do |key|
        names = _fields.map { |name, info| name unless info[key].nil? }.compact
        next if names.blank?
        (to_single_validates[names.first] ||= '') << ", #{key}: true" and next if names.size == 1
        model_rb_stack.last << "validates *%i[ #{names.join(' ')} ], exclusion: [ nil ]\n" and next if key == :null
        render_multi_validates(names, ", #{key}: true")
      end
      model_rb_stack.last << "\n"

      _fields.each do |name, info|
        info.slice!(*%i[ validates_associated inclusion exclusion format length numericality ])
        options = ''
        options << (to_single_validates[name] || '')
        info.each { |key, value| options << ", #{key}: #{pr(value, :full)}" }
        if options.present?
          content = "validates :#{name}#{options}"
          content << ', allow_nil: true' if allow_nil?(name)
          model_rb_stack.last << content << "\n"
        end
      end
      model_rb_stack.last << "\n"
    end

    def render_multi_validates(attrs, content)
      return model_rb_stack.last << "validates *%i[ #{attrs.join(' ')} ]#{content}, allow_nil: true\n" if allow_nil?(attrs)

      # model_rb_stack.last << "validates :#{(attrs - allow_nil).join(', :')}, #{content}\n" if (attrs - allow_nil).present?
      # model_rb_stack.last << "validates :#{allow_nil.join(', :')}, #{content}, allow_nil: true\n" if allow_nil.present?
      attrs.each { |attr| (to_single_validates[attr] ||= '') << content }
    end

    def run
      Dir['./app/**/*_mdoc.rb'].each { |file| require file }
      descendants.each do |mdoc|
        model_file_name = mdoc.model_name.underscore
        model_path = "app/models/#{model_file_name}#{mdoc.version}.rb"
        mg_next_version = ::ActiveRecord::Migration.next_migration_number(::ActiveRecord::Migrator.current_version)
        mg_file_name = "#{mg_next_version}_create_#{model_file_name.pluralize}"
        mg_path = "db/migrate/#{mg_file_name}#{mdoc.version}.rb"
        fbot_path = "spec/factories/#{model_file_name.pluralize}#{mdoc.version}.rb"
        doc_path = "app/_docs/#{mdoc.doc_version}/#{model_file_name.pluralize}_doc.rb"

        # if Config.overwrite_files || !File::exist?(model_path)
        if true
          mdoc.fields_to_migration
          mdoc.fields_to_fbot
          File.open(model_path, 'w') { |file| file.write mdoc.model_rb.sub("\n\n\nend\n", "\nend\n") }
          puts "[Zero] Model file has been generated: #{model_path}"
          # File.open(mg_path, 'w') { |file| file.write mdoc.migration_rb.sub("\n\n\nend\n", "\nend\n") }
          # puts "[Zero] Migration file has been generated: #{mg_path}"
          File.open(fbot_path, 'w') { |file| file.write mdoc.fbot_rb.sub("\n  \n  end\n", "\n  end\n") }
          puts "[Zero] Factory file has been generated: #{fbot_path}"

          if mdoc.doc_version
            File.open(doc_path, 'w') { |file| file.write mdoc.doc_rb }
            puts "[Zero] Doc file has been generated: #{doc_path}"
          end
        end
      end
    end

    def fields_to_migration
      soft_destroy = fields.delete(:deleted_at)
      fields[:deleted_at] = soft_destroy unless soft_destroy.nil?
      type_max_length = fields.values.map(&:first).map(&:length).sort.last
      name_max_length = fields.keys.map(&:length).sort.last
      key_order = %i[ foreign_key polymorphic null default index unique ] # TODO

      fields.each do |name, (type, *info)|
        type = type.to_s.ljust(type_max_length)
        info = info.reduce({ }, :merge)
        migration_indexes << name and info.delete(:index) if info.delete(:unique)

        info = key_order.map { |key| { key => info[key] } if info.key?(key) }.compact.reduce({ }, :merge)
        params = info.present? ? ("#{name},".ljust(name_max_length + 2) << pr(info)) : name.to_s

        migration_rb_stack.last << "t.#{type} :#{params}\n"
      end
    end

    def indexes_to_migration
      return nil if migration_indexes.blank?
      "\n" << migration_indexes.map do |name|
        <<~INDEX
          add_index :#{model_name.underscore.pluralize}, :#{name}, unique: true
        INDEX
      end.join
    end

    def fields_to_fbot
      name_max_length = fields.keys.map(&:length).sort.last
      fields.each do |name, (type, *info)|
        next if type == :references
        info = info.reduce({ }, :merge)
        allow_nil = !info.key?(:null) && !info.key?(:absence)

        if type == :belongs_to
          fbot_rb_stack.last << "#{name}\n"
        else
          value = info[:default]
          value = pr(info[:inclusion]&.first) if value.nil?
          value = TYPE_TO_DEFAULT_VAL[type] if value.nil?

          fbot_rb_stack.last << <<~BOT
            #{'# ' if allow_nil}#{name.to_s.ljust(name_max_length)} #{value}
          BOT
        end
      end
    end

    def model_rb
      <<~MODEL
        # *** Generated by Zero [ please make sure that you have checked this file ] ***

        class #{model_name} < ApplicationRecord
          #{add_ind_to model_rb_stack.last}
        end

        __END__

        #{migration_rb_stack.last}
        #{indexes_to_migration}
      MODEL
    end

    def migration_rb
      <<~MG
        # *** Generated by Zero [ please make sure that you have checked this file ] ***

        class Create#{model_name.pluralize} < ActiveRecord::Migration[5.1]
          def change
            create_table :#{model_name.underscore.pluralize}, options: 'ROW_FORMAT=DYNAMIC DEFAULT CHARSET=utf8' do |t|
              #{add_ind_to migration_rb_stack.last, 3}
              t.timestamps
            end
            #{add_ind_to indexes_to_migration, 2}
          end
        end
      MG
    end

    def fbot_rb
      <<~BOT
        # *** Generated by Zero [ please make sure that you have checked this file ] ***

        FactoryBot.define do
          factory :#{model_name.underscore} do
            #{add_ind_to fbot_rb_stack.last, 2}
          end
        end
      BOT
    end

    def doc_rb
      name = model_name.underscore
      <<~DOC
        # *** Generated by Zero [ please make sure that you have checked this file ] ***

        class #{model_name.pluralize}Error < V1Error
          include CUDFailed, AuthFailed
        
          # set_for :action
          # mattr_reader :name, '', ERROR_BEGIN
        end
        
        # TODO: when use it, open the comment
        class Api::#{doc_version.upcase}::#{model_name.pluralize}Doc# < ApiDoc
          components { schema #{model_name} }

          api :index, 'GET list of #{name.pluralize}', builder: :index do
          end

          api :show, 'GET the specified #{name}', builder: :show, use: id

          api :create, 'POST create a #{name}', builder: :success_or_not do
            form! 'for creating the specified #{name}', data: {
            }
          end

          api :update, 'PATCH update the specified #{name}', builder: :success_or_not, use: id do
            form! 'for updating the specified #{name}', data: {
            }
          end

          api :destroy, 'DELETE the specified #{name}', builder: :success_or_not, use: id

          g
        end
      DOC
    end
  end
end

__END__

(1) validates_associated
如果模型和其他模型有关联，而且关联的模型也要验证，要使用这个辅助方法。保存对象时，会在相关联的每个对象上调用 valid? 方法。
`validates_associated :books`
不要在关联的两端都使用 validates_associated，这样会变成无限循环。

(2) inclusion - in & exclusion - ex
这个辅助方法检查属性的值是否(不)在指定的集合中。集合可以是任何一种可枚举的对象。
`validates :size, inclusion: %w(small medium large)`

(3) format
这个辅助方法检查属性的值是否匹配 :with 选项指定的正则表达式。
`validates :legacy_code, format: /\A[a-zA-Z]+\z/`

(4) length - lth
这个辅助方法验证属性值的长度，有多个选项，可以使用不同的方法指定长度约束：
```
  validates :name, length: { minimum: 2 }
  validates :bio, length: { maximum: 500 }
  validates :password, length: { in: 6..20 }
  validates :registration_number, length: { is: 6 }
```

(5) numericality - num: { int, gt gte, eq, lt lte }
这个辅助方法检查属性的值是否只包含数字。
默认情况下，匹配的值是可选的正负符号后加整数或浮点数。如果只接受整数，把 :only_integer 选项设为 true。
```
  validates :points, numericality: true
  validates :games_played, numericality: { only_integer: true }
```
除了 :only_integer 之外，这个方法还可指定以下选项，限制可接受的值：
  :greater_than：属性值必须比指定的值大。
  :greater_than_or_equal_to：属性值必须大于或等于指定的值。
  :equal_to：属性值必须等于指定的值。
  :less_than：属性值必须比指定的值小。
  :less_than_or_equal_to：属性值必须小于或等于指定的值。
  :other_than：属性值必须与指定的值不同。
  :odd：如果设为 true，属性值必须是奇数。
  :even：如果设为 true，属性值必须是偶数。

(6) presence - should_blank & absence - not_blank
这个辅助方法检查指定的属性是否为非空 / 空值。它调用 blank? 方法检查值是否为 nil 或空字符串，即空字符串或只包含空白的字符串。
`validates :name, :login, :email, presence: true`
验证布尔值字段是否存在: `validates :boolean_field_name, exclusion: [nil]`
如果要确保关联对象存在，需要测试关联的对象本身是否存在，而不是用来映射关联的外键。做法见：
  https://ruby-china.github.io/rails-guides/v5.0/active_record_validations.html#presence

(7) uniqueness - unique
这个辅助方法在保存对象之前验证属性值是否是唯一的。
该方法不会在数据库中创建唯一性约束，所以有可能两次数据库连接创建的记录具有相同的字段值。为了避免出现这种问题，必须在数据库的字段上建立唯一性索引。
`validates :email, uniqueness: true`
:scope 选项用于指定检查唯一性时使用的一个或多个属性：
`validates :name, uniqueness: { scope: :year }`
