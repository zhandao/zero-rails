class GoodMdoc < ModelDoc
  soft_destroy

  string :name
  scope :ordered
  imethod :change_online
end
