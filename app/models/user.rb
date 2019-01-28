class User < ApplicationRecord
  builder_support

  soft_destroy

  act_as_i_am_i_can

  # enum status: [ :active, :archived ]
  # enum status: { active: 0, archived: 1 }

  has_secure_password

  def jwt_payload
    {
        id: id,
        token_version: token_version
    }
  end

  def jwt_claim
    {
        exp_in: 14.days
    }
  end
end
