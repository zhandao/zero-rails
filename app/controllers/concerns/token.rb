module Token
  attr_accessor :current_user, :payload

  def token
    return unless auth_header = request.headers['Authorization']&.split
    return unless auth_header.first == 'Bearer'
    auth_header.last
  end

  def token_verify!
    self.payload = Security::JWT.analyze token
  end

  def user_token_verify!
    return if current_user.present?

    token_verify!
    self.current_user = User.find_by id: payload&.[](:id)
    raise JWT::VerificationError if current_user.nil?
    right_hash = current_user.jwt_payload[:hash]
    raise JWT::VerificationError unless right_hash == payload[:hash]
  end
end
