require './config/initializers/open_api'
Object.const_set('Boolean', 'boolean')
OpenApi.write_docs generate_files: !Rails.env.production?

require './config/initializers/generators'
NormalSpdoc.run
RequestSpdoc.run
