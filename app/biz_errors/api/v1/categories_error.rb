class CategoriesError < V1Error
  include CUDFailed, AuthFailed
end
