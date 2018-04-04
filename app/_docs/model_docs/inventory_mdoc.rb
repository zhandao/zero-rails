class InventoryMdoc < ModelDoc
  # v 0

  belongs_to :store
  belongs_to :good

  int! :amount, :not_blank, default: 0, num: { int: true, gte: 0 }
  attrs!

  im :increase
  im :decrease
end
