# frozen_string_literal: true

class Error::Goods < Error::Api
  code_start_at 400

  include Error::Concerns::Failed

  group :change_onsale do
    mattr_reader :change_onsale_failed
  end
end
