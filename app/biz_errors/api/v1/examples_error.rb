class ExamplesError < V1Error
  set_for :index
  mattr_reader :name_not_found, 'can not find the name', 404
end
