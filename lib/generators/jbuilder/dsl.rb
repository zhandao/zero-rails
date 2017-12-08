module Generators::Jbuilder
  module DSL
    def self.included(base)
      base.extend Generators::Jbuilder::ClassMethods
    end
  end

  module ClassMethods
    def api action, summary = '', http: nil, builder: nil, skip: [ ], use: [ ], &block
      api = super(action, summary, http: http, skip: skip, use: use, &block)
      (@api_actions ||= [ ]) << action
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
        File.open(file_path, 'w') { |file| file.write config.templates[builder] }
        puts "[ZRO] JBuilder file has been generated: #{path}/#{action}"
      end
    end
  end
end
