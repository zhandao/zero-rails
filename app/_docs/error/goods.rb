class Error::Goods < Error::Api
  include Error::Concerns::Failed

  group :change_onsale do
    mattr_reader :change_onsale_failed, '', 700
  end
end
