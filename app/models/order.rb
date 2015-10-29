class Order < ActiveRecord::Base
	belongs_to :shop
	belongs_to :shopper

	has_one    :post
	has_one    :reward, -> {uniq}, through: :post,  source: :reward

	def self.new_from_bc_live(store_hash, uid)

		shop = Shop.find_by(provider: "bigcommerce", store_hash: store_hash)

		shop.config_bc_client

		if Bigcommerce::Order.find(uid).status != "incomplete"
			new_order 		  = Bigcommerce::Order.find(uid)


			#First, get this order_address in case
			begin
				new_order_address = Bigcommerce::OrderShippingAddress.all(uid)[0]
			rescue => e
				AdminMailer.delay.error_email(e)
			end

			#there should be a customer ID but somehow it can be so that there's not...
			if new_order.customer_id==0

				customer_address = new_order_address

				#this is the only thing missing from the order address. we have to pass it alone because
				#wif the customer_id was 0 asking for the address_type will throw an error
				address_type = "none"
			else
				begin
					customer_address  = Bigcommerce::CustomerAddress.all(new_order.customer_id)[0]
					address_type = customer_address.address_type
				rescue => e
					AdminMailer.delay.error_email(e)
				end
			end


			email = new_order.billing_address[:email]

			#find or create the shopper the order is linked to
			shopper = Shopper.from_bc_order(customer_address, email, address_type)

			order = Order.find_or_create_by(shop_id: shop.id, uid: uid) do |o|
				o.shopper_id				= shopper.id

				o.first_name				= new_order_address.first_name
				o.last_name					= new_order_address.last_name

				o.status 					= new_order.status
				#should be able to figure out S&H cost from the difference
				#this is all excluding-tax
				o.subtotal 					= new_order.subtotal_ex_tax.to_f
				o.discount_amount			= new_order.discount_amount.to_f
				o.coupon_amount 			= new_order.coupon_discount.to_f
				o.store_credit_amount 		= new_order.store_credit_amount.to_f
				o.gift_certificate_amount	= new_order.gift_certificate_amount.to_f
				o.total						= new_order.total_ex_tax.to_f

				o.item_count				= new_order.items_total.to_i

				o.payment_method			= new_order.payment_method
				o.payment_status			= new_order.payment_status

				o.notes						= new_order.staff_notes
				o.message					= new_order.customer_message
				o.source					= new_order.order_source

				o.email						= new_order.billing_address[:email].downcase

				o.city						= new_order_address.city
				o.state 					= new_order_address.state
				o.zipcode					= new_order_address.zip
				o.country					= new_order_address.country
				o.country_code				= new_order_address.country_iso2

				o.cents_per_like			= shop.brand.cents_per_like
				o.dollars_per_follow		= shop.brand.dollars_per_follow
				o.max_total_allowed			= shop.brand.max_total_allowed
				o.expires_at				= Time.now + shop.brand.days_to_post.days

				if new_order.date_shipped.present?
					o.date_shipped			= DateTime.parse(new_order.date_shipped)
				end

				o.save!
			end

			#send appropriate email to shopper
			if shopper.uid.nil?
				ShopperMailer.delay.authorize_shopper_instagram(
				shopper.email,
				shop.brand.name,
				shop.brand.nickname,
				order.cents_per_like,
				order.dollars_per_follow,
				shop.brand.days_to_post,
				order.max_total_allowed)
			else
				ShopperMailer.delay.offer_from_order(
				shopper.email,
				shop.brand.name,
				shop.brand.nickname,
				order.cents_per_like,
				order.dollars_per_follow,
				shop.brand.days_to_post,
				order.max_total_allowed)
			end
		end
	end
end