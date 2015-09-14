class SubscribeToOrdersWorker
	include Sidekiq::Worker


	def perform(token, store_hash)

		Bigcommerce.configure do |config|
			config.store_hash   = store_hash
			config.client_id    = ENV['BC_CLIENT_ID']
			config.access_token = token
		end
		
		Bigcommerce::Webhook.create(
			scope: 'store/order/*',
			destination: ENV['BC_SUBSCRIBE_URL']
		)

	end
end