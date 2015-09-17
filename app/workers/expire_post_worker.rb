class ExpirePostWorker
	include Sidekiq::Worker


	def perform(post_id)
		post = Post.find(post_id)
		post.update_likes

		shop = post.order.shop

		brand = shop.brand
		brand.update_followers(post_id)

		reward = post.reward
		reward.calculate_total

		if reward.payable_total > 0
			shop.create_coupon(reward)
			#TODO Send Email to shopper
		else
			#TODO Send Email to shopper apologizing that they got 0likes
		end

	end
end