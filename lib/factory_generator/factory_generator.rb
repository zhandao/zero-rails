module FactoryGenerator
  def self.included(base)
    base.class_eval do
      attr_accessor :fields, :scopes, :imethods, :cmethods
    end
    base.extend ClassMethods
  end

  module ClassMethods
    def run
      super() rescue nil
      Dir['./app/**/*_mdoc.rb'].each { |file| require file }
      descendants.each do |mdoc|
        *dir_path, file_name = mdoc.path.split('/')
        dir_path = "spec/factories/#{dir_path.join('/')}"
        FileUtils.mkdir_p dir_path
        file_path = "#{dir_path}/#{file_name}.rb"

        # if Config.overwrite_files || !File::exist?(file_path)
        if true
          File.open(file_path, 'w') { |file| file.write mdoc.whole_file }
          puts "[Zero] Factory file has been generated: #{file_path}"
        end
      end
    end
  end
end
