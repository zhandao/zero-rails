# frozen_string_literal: true

class Error::Categories < Error::Api
  code_start_at 300

  include Error::Concerns::Failed

  # group :create do
  #   mattr_reader :
  # end

  # group :update do
  #   mattr_reader :
  # end
end
