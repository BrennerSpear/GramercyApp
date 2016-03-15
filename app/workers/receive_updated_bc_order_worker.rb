class ReceiveUpdatedBcOrderWorker
	include Sidekiq::Worker


	def perform(new_order)
		producer = new_order['producer'].split('/')
		store_hash = producer[1]

		uid = new_order['data']['id']

		Order.update_from_bc_live(store_hash, uid)

	end


end