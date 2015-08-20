class ExpirePostWorker
	include Sidekiq::Worker


	def perform(post_id)
		post = Post.find(post_id)
		brand = post.order.shop.brand
		brand.update_followers(post_id)

		#Send Email to shopper

	end
end