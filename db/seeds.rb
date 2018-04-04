# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
User.create name: 'zhandao', password: 'zhandao', phone_number: '13912345678'
Role.create name: 'man'
Permission.create name: 'fight'
Permission.create name: 'fighting'
RolePermission.create role: Role.first, permission: Permission.first
Role.create name: 'test_role'
EntityRole.create entity: User.take, role: Role.last # is `test_role`
Permission.create name: 'test_permission'
EntityPermission.create entity: User.take, permission: Permission.last # can `test_permission`

Role.create name: 'father'
Permission.create name: 'father_permission'
RolePermission.create role: Role.last, permission: Permission.last
Role.create name: 'son', base_role: Role.find_by(name: 'father')
EntityRole.create entity: User.take, role: Role.last # is `son`, and `father`; can `father_permission`


Category.create name:"办公用品大类"
Category.create name:"生活用品大类"
Category.create name:"文件收纳类", base_category_id: 1
Category.create name:"纸张用品类", base_category_id: 1
Category.create name:"清洁耗材类", base_category_id: 2


stores = %w[store1 store2 store3]
stores.size.times { |i| Store.create address: i + 1, name: stores[i] } # FIXME


Good.create name: "文件收纳1", unit: "个",	price: 7.13,  category_id: 3
Good.create name: "文件收纳2", unit: "个",	price: 5.89,  category_id: 3
Good.create name: "文件收纳3", unit: "个",	price: 8.5,	  category_id: 3
Good.create name: "纸张用品1", unit: "个",	price: 12.1,  category_id: 4
Good.create name: "纸张用品2", unit: "个",	price: 2.85,  category_id: 4
Good.create name: "纸张用品3", unit: "个",	price: 1.9,	  category_id: 4
Good.create name: "纸张用品4", unit: "个",	price: 1.14,  category_id: 4
Good.create name: "纸张用品5", unit: "个",	price: 0.65,  category_id: 4
Good.create name: "清洁耗材1", unit: "个",	price: 12.35, category_id: 5
Good.create name: "清洁耗材2", unit: "个",	price: 1.68,  category_id: 5
Good.create name: "清洁耗材3", unit: "个",	price: 24.7,  category_id: 5
