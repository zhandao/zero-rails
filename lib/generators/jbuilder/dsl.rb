module Generators::Jbuilder
  module DSL
    def self.included(base)
      base.extend Generators::Jbuilder::ClassMethods
    end
  end

  module ClassMethods
    include Generators::Helpers

    def api action, summary = '', http: nil, builder: nil, skip: [ ], use: [ ], &block
      api = super(action, summary, http: http, skip: skip, use: use, &block)
      return unless Rails.env.development?
      generate(api.action_path, builder)
    end

    def generate(action_path, builder)
      return unless (config = Generators::Jbuilder::Config).enable
      return if builder.nil?

      path, action = action_path.split('#')
      dir_path = "app/views/#{path}"
      FileUtils.mkdir_p dir_path
      file_path = "#{dir_path}/#{action}.json.jbuilder"

      if config.overwrite || !File.exist?(file_path)
        write :JBuilder, config.templates[builder], to: file_path
      end
    end
  end
end
