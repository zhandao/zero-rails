class InventroiesError < V1Error
  include CUDFailed, AuthFailed
end
