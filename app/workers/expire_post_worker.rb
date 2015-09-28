class ExpirePostWorker
	include Sidekiq::Worker


	def perform(post_id)
		post = Post.find(post_id)
		post.update_likes

		shop = post.order.shop

		brand = shop.brand
		brand.update_followers(post_id)

                reward = Reward.from_post(post.id)
		reward.calculate_total

		if reward.payable_total < reward.calculated_total
			shop.create_coupon(reward)
			ShopperMailer.delay.coupon_code_hit_max(
        		post.shopper.email,
        		brand.name,
        		reward.likes,
        		reward.cents_per_like,
        		reward.followers_generated,
        		reward.dollars_per_follow,
                        post.image,
                        post.link,
        		reward.code,
        		reward.payable_total
        		)
		elsif reward.payable_total > 0
			shop.create_coupon(reward)
			ShopperMailer.delay.coupon_code(
        		post.shopper.email,
        		brand.name,
        		reward.likes,
        		reward.cents_per_like,
        		reward.followers_generated,
        		reward.dollars_per_follow,
                        post.image,
                        post.link,
        		reward.code,
        		reward.payable_total
        		)
		else
			ShopperMailer.delay.sorry_no_coupon(
        		post.shopper.email,
        		brand.name,
                        post.image,
                        post.link
        		)
		end

	end
end