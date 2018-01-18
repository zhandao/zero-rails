# class AdminMdoc < ModelDoc
#   # v 0
#   soft_destroy
#
#   has_many :entity_roles, as: :entity
#   has_many :roles, through: :entity_roles
#   has_many :entity_permissions, as: :entity
#   has_many :permissions, through: :entity_permissions
#
#   str! :email, :not_blank
#   str! :uid, :not_blank
#   str  :ad
#   str  :phone
#   str  :department
#   str  :creator
#   int  :token_version, default: 1
#   datetime :deleted_at
#   attrs!
#
#   im :name
#   im :logout
#   im :add
# end
