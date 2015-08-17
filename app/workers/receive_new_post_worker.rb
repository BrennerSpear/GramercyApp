class ReceiveNewPostWorker
	include Sidekiq::Worker


	def perform(new_post)
		shopper_id = new_post["object_id"]
		media_id		  = new_post["data"]["media_id"]

		#create new post
		post = Post.from_live_update(shopper_id, media_id)
		
		#connect it to an order if one exists
		post.connect_to_order

		#create the reward 
		if post.order.present?
			Reward.from_post(post.id)
		end


	end
end