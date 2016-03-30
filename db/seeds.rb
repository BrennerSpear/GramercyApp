Admin.create(email: 'admin@gramercyapp.com', password: 'gramercy')

Brand.create(
	email:    'phil.knight@nike.com',
	password: 'password',
	uid: 	  '22268966',
	name:     'nike'
			 )

Shop.create(
	brand_id: 		"1")

Order.create(
	shop_id: "1",
	email: "brenner@test.com",
	cents_per_like: 1,
	dollars_per_follow: 1,
	max_total_allowed: 100,
	days_to_post: 0)

Order.create(
	shop_id: "1",
	email: "gramercy@test.com",
	cents_per_like: 1,
	dollars_per_follow: 1,
	max_total_allowed: 100,
	days_to_post: 0)

Order.create(
	shop_id: "1",
	email: "ig@test.com",
	cents_per_like: 1,
	dollars_per_follow: 1,
	max_total_allowed: 100,
	days_to_post: 0)

Order.create(
	shop_id: "1",
	email: "brenner@test.com",
	cents_per_like: 2,
	dollars_per_follow: 1,
	max_total_allowed: 100,
	days_to_post: 1)

Order.create(
	shop_id: "1",
	email: "gramercy@test.com",
	cents_per_like: 2,
	dollars_per_follow: 1,
	max_total_allowed: 100,
	days_to_post: 1)

Order.create(
	shop_id: "1",
	email: "ig@test.com",
	cents_per_like: 2,
	dollars_per_follow: 1,
	max_total_allowed: 100,
	days_to_post: 1)

Order.create(
	shop_id: "1",
	email: "brenner@test.com",
	cents_per_like: 3,
	dollars_per_follow: 1,
	max_total_allowed: 100,
	days_to_post: 2)

Order.create(
	shop_id: "1",
	email: "gramercy@test.com",
	cents_per_like: 3,
	dollars_per_follow: 1,
	max_total_allowed: 100,
	days_to_post: 2)

Order.create(
	shop_id: "1",
	email: "ig@test.com",
	cents_per_like: 3,
	dollars_per_follow: 1,
	max_total_allowed: 100,
	days_to_post: 2)

Post.create(
	shopper_id: "1",
	order_id: "1",
	media_type: "image",
	link: "wrong",
	image: "image link",
	media_id: "2222222222",
	tagged_accounts: ["22268966"],
	created_at: Time.now)
