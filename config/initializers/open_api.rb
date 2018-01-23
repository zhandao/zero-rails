require 'open_api'

# More Information: https://github.com/zhandao/zero-rails_openapi/blob/master/documentation/examples/open_api.rb
OpenApi::Config.tap do |c|
  c.instance_eval do
    open_api :zero_rails, base_doc_class: ApiDoc
    info version: '0.0.1', title: 'Zero Rails APIs', description: 'API documentation of Zero-Rails Application.'
    server 'http://localhost:3000', desc: 'Main (production) server'
    server 'http://localhost:3000', desc: 'Internal staging server for testing'
    bearer_auth :Token
    global_auth :Token
  end

  c.file_output_path = 'app/_docs/open_api'

  c.doc_location = [ './app/**/*_doc.rb' ]

  c.rails_routes_file = 'config/routes.txt'
end
