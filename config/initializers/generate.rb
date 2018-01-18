require './config/initializers/open_api'
require './config/initializers/generators'
Object.const_set('Boolean', 'boolean')
OpenApi.write_docs generate_files: Rails.env.development?

if Rails.env.development?
  [NormalSpdoc, RequestSpdoc, ModelDoc ].each(&:run)
end
