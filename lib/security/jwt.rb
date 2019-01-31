# frozen_string_literal: true

# https://github.com/jwt/ruby-jwt
module Security::JWT
  # JWT key at config/secret.rb
  @key = Rails.application.secrets.jwt
  @algorithm = 'HS256'

  module_function

  def generate(payload, claim = { })
    claim.tap do |it|
      it[:exp] ||= (it.delete(:exp_in)&.+ Time.current.to_i) || it.delete(:exp_at)
      it[:nbf] ||= it.delete(:effective_time)
    end.delete_if { |_, v| v.blank? }
    JWT.encode payload.merge(claim), @key, @algorithm
  end

  def analyze(token)
    payload = JWT.decode(token, @key, true, algorithm: @algorithm).first
    HashWithIndifferentAccess.new payload
  end
end


__END__

module JWT
  class EncodeError < StandardError; end
  class DecodeError < StandardError; end
  class VerificationError < DecodeError; end
  class ExpiredSignature < DecodeError; end
  class IncorrectAlgorithm < DecodeError; end
  class ImmatureSignature < DecodeError; end
  class InvalidIssuerError < DecodeError; end
  class InvalidIatError < DecodeError; end
  class InvalidAudError < DecodeError; end
  class InvalidSubError < DecodeError; end
  class InvalidJtiError < DecodeError; end
  class InvalidPayload < DecodeError; end
end