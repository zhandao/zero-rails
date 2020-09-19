# frozen_string_literal: true

module TokenForModel
  # [Note] Make sure jwt_payload() is defined in your Model.
  # [Note] JWT 第三部分是 signature，由不同环境的不同 secret 进行.
  def token
    Security::JWT.generate jwt_payload, jwt_claim
  end

  def jwt_claim
    {
        # exp_in: 30.days
    }
  end
end
