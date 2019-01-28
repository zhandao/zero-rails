# class ModelDocs::Foo < ModelDoc
#   soft_destroy
#
#   belongs_to :user, polymorphic: true
#   has_many :stars
#   self_joins :has_many
#
#   string! :name, %i[ index uniq show ], in: %i[ woo wow ], format: /wow|wow/, lth: { minimum: 2 }
#   integer :type, %i[ uniq not_blank ], num: { int: true, gte: 10 }
#   boolean! :activated, default: false, show: true
#   end_of_attrs
#
#   index :user, :name
#
#   scope :ordered
#
#   cmethod :bar
#
#   imethod :change_status, 'change its online status' do
#     wh 'there is no call to #page' do
#       it :success
#       it :does_something, is_expected: [1, 2, 3]
#     end
#   end
#
#   imethod :cool
#
#   # g 'v1'
# end
