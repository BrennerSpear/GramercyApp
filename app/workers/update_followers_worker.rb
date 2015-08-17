class UpdateFollowersWorker
	include Sidekiq::Worker


	def perform(new_post)

		shopper_uid = new_post["object_id"]

		@shopper = Shopper.find_by_uid(shopper_uid)
		Shopper.update_followers(@shopper, type)
	end
end