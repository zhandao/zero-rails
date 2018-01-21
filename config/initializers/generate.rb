require './config/initializers/open_api'
Object.const_set('Boolean', 'boolean')
OpenApi.write_docs generate_files: Rails.env.development?

if Rails.env.development?
  require './config/initializers/generators'
  [ NormalSpdoc, RequestSpdoc, ModelDoc ].each(&:run)
end
