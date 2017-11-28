module ModelDocDSL
  def self.included(base)
    base.class_eval do
      attr_accessor :fields, :scopes, :imethods, :cmethods
    end
    base.extend ClassMethods
    base.include FactoryGenerator
    base.include RspecGenerator::Model
  end

  module ClassMethods
    def run
      Dir['./app/**/*_mdoc.rb'].each { |file| require file }
      descendants.each do |mdoc|
        *dir_path, file_name = mdoc.path.split('/')
        dir_path = "app/model/#{dir_path.join('/')}"
        FileUtils.mkdir_p dir_path
        file_path = "#{dir_path}/#{file_name}.rb"

        # if Config.overwrite_files || !File::exist?(file_path)
        if true
          File.open(file_path, 'w') { |file| file.write mdoc.whole_file }
          puts "[Zero] Model file has been generated: #{file_path}"
        end
      end
    end

    def soft_destroy
      #
    end

    # alias_method :soft, :soft_destroy

    def field name, type
      #
    end

    %i[ string boolean integer datetime float text ].each do |type|
      define_method type do |name|
        field name, type
      end
    end

    def scope name
      #
    end

    def imethod name
      #
    end

    def cmethod name
      #
    end
  end
end
