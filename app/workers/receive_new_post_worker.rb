class ReceiveNewPostWorker
	include Sidekiq::Worker

	def perform(new_post)
		shopper_uid = new_post["object_id"]
		media_id	= new_post["data"]["media_id"]

		#create new post
		post = Post.from_live_update(shopper_uid, media_id)

		#connect it to an order if one exists
		post.connect_to_order

		#create the reward & set expiration worker timer
		if post.order.present?
			ExpirePostWorker.perform_in(Rails.configuration.expire_time, post.id)
			Reward.from_post(post.id)
		end

	end
end