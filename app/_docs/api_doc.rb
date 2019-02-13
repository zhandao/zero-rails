# frozen_string_literal: true

class ApiDoc < Object
  include OpenApi::DSL
  include AutoGenDoc
  include Generators::Jbuilder::DSL if Rails.env.development?
  include Generators::ApiDocSupport::DSL if Rails.env.development?
  unless Rails.env.development?
    def self.api action, summary = '', http: nil, builder: nil, &block
      super(action, summary, http: http, &block)
    end
  end
end

module OpenApi
  module DSL
    class Api
      def response_data(schema)
        response 0, 'success', :json, data: { data: schema }
      end
    end
  end
end
