class InitiateGetFollowersWorker
	include Sidekiq::Worker


	def perform(shopper, type)
		@shopper = Shopper.find(shopper)
		Shopper.initiate_getting_followers(@shopper, type)
	end
end