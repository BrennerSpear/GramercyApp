class SubscribeToShopperWorker
	include Sidekiq::Worker


	def perform(access_token)
		client = Instagram.client(access_token: access_token, client_id: ENV['IG_API_KEY'], client_secret: ENV['IG_SECRET'])
		client.create_subscription('user', 'https://dev-gramercy-app.herokuapp.com/shopper/omniauth_callbacks/post')
	end
end