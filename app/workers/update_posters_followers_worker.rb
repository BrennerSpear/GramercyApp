class UpdatePostersFollowersWorker
	include Sidekiq::Worker


	def perform(new_post)

		shopper_uid = new_post["object_id"]

		if shopper = Shopper.find_by_uid(shopper_uid)
			shopper.update_followers
		end
	end
end