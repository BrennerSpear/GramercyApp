# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Admin.create(email: 'admin@gramercyapp.com', password: 'gramercy')

Brand.create(
	email:    'phil.knight@nike.com',
	password: 'password',
	uid: 	  '22268966'
			 )

Shop.create(
	shopify_domain: "place_holder",
	shopify_token:  "place_holder",
	brand_id: 		"1")

Order.create(
	shop_id: "1",
	email: "blspear@gmail.com",
	cents_per_like: 5,
	dollars_per_like: 1.50,
	max_total_allowed: 215)

