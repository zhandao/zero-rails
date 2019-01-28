# class ModelDocs::Store < ModelDoc
#   # v 0
#   soft_destroy
#
#   has_many :inventories, dependent: :destroy
#   has_many :goods, through: :inventories
#
#   str! :name, :not_blank
#   str! :address, :not_blank
#   attrs!
#
#   after_create :create_inventory_records
# end
