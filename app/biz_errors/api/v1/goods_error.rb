class GoodsError < V1Error
  include CUDFailed, AuthFailed

  set_for :change_online
  mattr_reader :change_online_failed, '', ERROR_BEGIN
end
