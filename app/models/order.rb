class Order < ActiveRecord::Base
	belongs_to :shop
	belongs_to :shopper

	has_one    :post
	has_one    :reward, -> {uniq}, through: :post,  source: :reward

	validates_uniqueness_of :uid, scope: :shop_id

	def self.create_order

		shop = Shop.find(3)

		shop.config_bc_client

		@order = Bigcommerce::Order.create(
		  billing_address: {
		    first_name: Faker::Name.first_name,
		    last_name: Faker::Name.last_name,
		    street_1: Faker::Address.street_name,
		    city: Faker::Address.city,
		    state: Faker::Address.state,
		    zip: Faker::Address.zip,
		    country: 'Congo',
		    email: 'gramercy1@sharklasers.com'
		  },
		  products: [
		    {
		      product_id: 70,
		      quantity: 1
		    }
		  ],
		  status_id: 9
		)

	end

	def self.new_from_bc_live(store_hash, uid)

		shop = Shop.find_by(provider: "bigcommerce", store_hash: store_hash)

		shop.config_bc_client

		if Order.find_by(shop_id: shop.id, uid: uid).nil?
			if (Bigcommerce::Order.find(uid).status != "Incomplete" &&
				Bigcommerce::Order.find(uid).status != "Cancelled" &&
				Bigcommerce::Order.find(uid).status != "Refunded" &&
				Bigcommerce::Order.find(uid).status != "Disputed")

				new_order 		  = Bigcommerce::Order.find(uid)

				if new_order.customer_id==0 || Bigcommerce::CustomerAddress.all(new_order.customer_id)[0].nil?
					begin
						customer_address = Bigcommerce::OrderShippingAddress.all(uid)[0]
					rescue => e
						e = e + " There was a problem with customer address"
						AdminMailer.delay.error_email(e)
					end
					#this is the only thing missing from the order address (its in the customer address)
					address_type = "none"
				else

					begin
						customer_address  = Bigcommerce::CustomerAddress.all(new_order.customer_id)[0]
						address_type = customer_address.address_type
					rescue => e
						e = e + " There was a problem with customer address"
						AdminMailer.delay.error_email(e)
					end
				end


				email = new_order.billing_address[:email]

				#find or create the shopper the order is linked to
				shopper = Shopper.from_bc_order(customer_address, email, address_type)

				order = Order.find_or_create_by(shop_id: shop.id, uid: uid) do |o|
					o.shopper_id				= shopper.id

					o.first_name				= customer_address.first_name
					o.last_name					= customer_address.last_name

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

					o.city						= customer_address.city
					o.state 					= customer_address.state
					o.zipcode					= customer_address.zip
					o.country					= customer_address.country
					o.country_code				= customer_address.country_iso2

					o.cents_per_like			= shop.brand.cents_per_like
					o.dollars_per_follow		= shop.brand.dollars_per_follow
					o.max_total_allowed			= shop.brand.max_total_allowed
					o.expires_at				= Time.now + shop.brand.days_to_post.days

					if new_order.date_shipped.present?
						o.date_shipped			= DateTime.parse(new_order.date_shipped)
					end

					begin
						o.save
					rescue ActiveRecord::RecordNotUnique
						#Do Nothing. This happens all the damn time since Bigcommerce double&triple sends
						#their POST and it causes this error 
					end
					
				end

				#email address from an in-person sale w/ no email address is usually ""
				#Causes ArgumentError
				#This is a temporary fix
				#TODO
				if shopper.email != ""
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

		else
			new_order = Bigcommerce::Order.find(uid)
			order     = Order.find_by(shop_id: shop.id, uid: uid)

			order.status 		 = new_order.status
			order.payment_method = new_order.payment_method
			order.payment_status = new_order.payment_status

			if new_order.date_shipped.present?
				order.date_shipped	= DateTime.parse(new_order.date_shipped)
			end

			order.save

		end
	end
end