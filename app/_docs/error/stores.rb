# frozen_string_literal: true

class Error::Stores < Error::Api
  code_start_at 500

  include Error::Concerns::Failed

  # group :create do
  #   mattr_reader :
  # end

  # group :update do
  #   mattr_reader :
  # end
end
