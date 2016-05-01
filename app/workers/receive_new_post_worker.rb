class ReceiveNewPostWorker
	include Sidekiq::Worker

	def perform(new_post)
		shopper_uid = new_post["object_id"]
		media_id	= new_post["data"]["media_id"]

		#some of the posts that come in will be the brands posting. We don't keep track of Brand's posts... for now
		if Shopper.find_by_uid(shopper_uid)
			#create new post
			post = Post.from_live_update(shopper_uid, media_id)

			#connect it to an order if one exists
			post.connect_to_order

			#set expiration worker timer
			if post.order.present?
				ContinueUpdatingPostWorker.perform_async(post.id, 101)
				ExpirePostWorker.perform_in(Rails.configuration.expire_time, post.id)
			end
		end

	end
end