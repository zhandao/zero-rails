require './config/initializers/open_api'
require './config/initializers/generators'
Object.const_set('Boolean', 'boolean')
OpenApi.write_docs generate_files: !Rails.env.production?

NormalSpdoc.run
RequestSpdoc.run
ModelDoc.run
