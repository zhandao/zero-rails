class StoresError < V1Error
  include CUDFailed, AuthFailed
end
