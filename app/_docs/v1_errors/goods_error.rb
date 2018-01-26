class GoodsError < V1Error
  include CUDFailed, AuthFailed

  set_for :change_onsale
  mattr_reader :change_onsale_failed, '', 700
end
