# class ModelDocs::User < ModelDoc
#   # v 0
#   soft_destroy
#
#   has_many :entity_roles, as: :entity
#   has_many :roles, through: :entity_roles
#   has_many :entity_permissions, as: :entity
#   has_many :permissions, through: :entity_permissions
#
#   str! :name
#   str! :password_digest, match: /^.{6,}$/
#   str :email
#   str :phone_number
#   attrs!
# end
