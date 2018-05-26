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
    self.current_user = User.find_by(id: payload&.[](:id), token_version: payload&.[](:token_version))
    raise JWT::VerificationError if current_user.nil?
  end
end
