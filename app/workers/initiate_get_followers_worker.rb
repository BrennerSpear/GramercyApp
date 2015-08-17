class InitiateGetFollowersWorker
	include Sidekiq::Worker


	def perform(shopper_id, type)
		@shopper = Shopper.find(shopper_id)
		Shopper.initiate_getting_followers(@shopper, type)
	end
end