class GetBcStoreInfoWorker
	include Sidekiq::Worker

	def perform(token, store_hash)

		shop = Shop.find_by(provider: "bigcommerce", store_hash: store_hash)

		shop.add_bc_store_info
	end
end