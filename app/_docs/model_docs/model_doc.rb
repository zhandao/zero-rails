class ModelDoc
  include ModelDocDSL
  # soft_destroy
  #
  # desc 'name'
  # string :name, range: { ge: 1 }, examples: [ 'name' ], dft_scope: :not_null, show: false
end
