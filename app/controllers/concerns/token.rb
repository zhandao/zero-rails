module Token
  attr_accessor :current_user, :payload

  def token
    request.headers[jwt_field_name || 'Token'] || params[jwt_field_name || :token]
  end

  def token_verify!
    self.payload = Security::JWT.analyze token
  end

  def user_token_verify!
    token_verify!
    self.current_user = User.find_by id: payload&.[](:id)
    raise JWT::VerificationError if current_user.nil?
    right_hash = current_user.jwt_payload[:hash]
    raise JWT::VerificationError unless right_hash == payload[:hash]
  end

  def jwt_field_name; 'Token'; end
end
