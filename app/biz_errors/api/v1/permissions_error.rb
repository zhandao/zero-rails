class PermissionsError < V1Error
  include CUDFailed, AuthFailed
end
