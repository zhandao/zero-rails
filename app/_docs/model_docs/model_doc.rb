class ModelDoc
  include Generators::ModelDocSupport::DSL
  # string :name, range: { ge: 1 }, examples: [ 'name' ], dft_scope: :not_null, show: false
end
