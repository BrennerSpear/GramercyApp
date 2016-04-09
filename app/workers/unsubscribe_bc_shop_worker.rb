class UnsubscribeBcShopWorker
	include Sidekiq::Worker

	def perform(shop_id)
		shop = Shop.find(shop_id)

		shop.currently_installed = false
		shop.token = nil
		shop.save

		#make orders that are eligible no longer eligible
		ineligible_orders = Order.where('shop_id = ? AND expires_at > ?', shop_id, Time.now).pluck(:id)
		ineligible_orders.each do |id|
			order = Order.find(id)
			order.reward_eligible = false
			order.save
			#TODO needs to send an email to each of those customers and says sorry the offer is no longer on the table
		end

		count = ineligible_orders.count

		AdminMailer.delay.uninstall_email(shop.brand.name, shop.provider, count)
	end
end