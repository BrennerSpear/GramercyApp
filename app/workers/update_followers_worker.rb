class UpdateFollowersWorker
	include Sidekiq::Worker


	def perform(new_post)

		shopper_id = new_post["object_id"]

		@shopper = Shopper.find(shopper_id)
		Shopper.update_followers(@shopper, type)
	end
end