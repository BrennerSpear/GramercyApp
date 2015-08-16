class InitiateGetFollowersWorker
	include Sidekiq::Worker


	def perform(shopper, type)
		Shopper.initiate_getting_followers(shopper, type)
	end
end