class ExpirePostWorker
	include Sidekiq::Worker


	def perform(post_id)
		post = Post.find(post_id)
		post.update_likes

		brand = post.order.shop.brand
		brand.update_followers(post_id)
		


		reward = post.reward
		reward.calculate_total


		#Send Email to shopper

	end
end