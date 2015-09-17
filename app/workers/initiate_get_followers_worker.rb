class InitiateGetFollowersWorker
	include Sidekiq::Worker


	def perform(followable_id, type)
		if type=="Shopper"
			shopper = Shopper.find(followable_id)
			shopper.initiate_getting_followers(type)
		elsif type=="Brand"
			brand = Brand.find(followable_id)
			brand.initiate_getting_followers(type)
		end

	end
end