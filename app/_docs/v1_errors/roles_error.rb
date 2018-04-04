class RolesError < V1Error
  include CUDFailed, AuthFailed
end
