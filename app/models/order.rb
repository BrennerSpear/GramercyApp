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

			new_order 		 = Bigcommerce::Order.find(uid)

			positive_order_status = ["Pending","Shipped","Partially Shipped","Awaiting Payment","Awaiting Pickup","Awaiting Shipment","Completed","Awaiting Fulfillment"]
			#don't need this but nice to have here to show all positible 
			#negative_order_status = ["Incomplete","Refunded","Cancelled","Declined","Manual Verification Required","Disputed"]

			if (positive_order_status.include? new_order.status)

				address_array 		= Order.get_address_from_bc(new_order, uid)
				customer_address 	= address_array[0]
				order_address		= address_array[1]
				address_type 		= address_array[2]

				#pull out email
				email = new_order.billing_address[:email]

				#find or create the shopper the order is linked to
				shopper = Shopper.from_bc_order(customer_address, email, address_type)

				#create the new order
				order = Order.create_from_bc(shop, shopper, uid, new_order, order_address)

				#send offer to shopper (shoppers w/o IG info get an Auth link included)
				#don't send an email if it's the hardcoded in-store shopper w/ no email

				if (shopper.id != 1 && new_order.status == ("Shipped" || "Completed") && order.email_queued == false)
					Order.send_offer_to_shopper(shop, shopper, order)
				end
			end
		end

		return "Order.new_from_bc_live has run"
	end

	def self.update_from_bc_live(store_hash, uid)

		shop = Shop.find_by(provider: "bigcommerce", store_hash: store_hash)
		
		#orders are put into our DB if they're incomplete. Some incomplete orders get updated to a valid status
		#If the order doesn't exist but it's being updated, it doesn't exist in our DB yet, so we send it back to new_from_bc_live
		if Order.find_by(shop_id: shop.id, uid: uid).nil?
			Order.new_from_bc_live(store_hash, uid)
		else
			shop.config_bc_client
			new_order = Bigcommerce::Order.find(uid)

			order     = Order.find_by(shop_id: shop.id, uid: uid)

			order.status 		 = new_order.status
			order.payment_method = new_order.payment_method
			order.payment_status = new_order.payment_status

			if new_order.date_shipped.present?
				order.date_shipped	= DateTime.parse(new_order.date_shipped)
			end
			order.save

			#To prevent people from ordering then cancelling
			#TODO it should disconnect from the post, delete a reward if connected, and notify someone if they still try to get a coupon
			negative_order_status = ["Incomplete","Refunded","Cancelled","Declined","Manual Verification Required","Disputed"]

			#I could just make this half an 'else' statement, but I'm just being explicit. Idk if that's the right thing to do or not
			positive_order_status = ["Pending","Shipped","Partially Shipped","Awaiting Payment","Awaiting Pickup","Awaiting Shipment","Completed","Awaiting Fulfillment"]
			
			if (negative_order_status.include? new_order.status)
				order.reward_eligible = false
				order.save
			elsif (positive_order_status.include? new_order.status)
				order.reward_eligible = true
				order.save
			end

			shopper = order.shopper
			
			if (shopper.id != 1 && new_order.status == ("Shipped" || "Completed") && order.email_queued == false)
					Order.send_offer_to_shopper(shop, shopper, order)
			end

		end
	end

	def self.create_from_bc(shop, shopper, uid, new_order, customer_address)
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

		return order
	end

	def self.get_address_from_bc(new_order, uid)
		#If the customer is a guest, their bc id == 0
		#so we just set their address to their order's address
		order_address    = Bigcommerce::OrderShippingAddress.all(uid)[0]

		#Sometimes the customer does have a bc account, but no address, hence the second check added as an OR
		if (new_order.customer_id==0 || Bigcommerce::CustomerAddress.all(new_order.customer_id)[0].nil?)
			customer_address = order_address
			address_type 	 = "none"
		else
			customer_address = Bigcommerce::CustomerAddress.all(new_order.customer_id)[0]
			address_type	 = customer_address.address_type
		end

		return customer_address, order_address, address_type
	end

	def self.send_offer_to_shopper(shop, shopper, order)
		if shopper.uid.nil?
			ShopperMailer.delay_for(Rails.configuration.offer_email_delay).authorize_shopper_instagram(
			shopper.email,
			shop.brand.name,
			shop.brand.nickname,
			order.cents_per_like,
			order.dollars_per_follow,
			shop.brand.days_to_post,
			order.max_total_allowed)
		else
			ShopperMailer.delay_for(Rails.configuration.offer_email_delay).offer_from_order(
			shopper.email,
			shop.brand.name,
			shop.brand.nickname,
			order.cents_per_like,
			order.dollars_per_follow,
			shop.brand.days_to_post,
			order.max_total_allowed)
		end
		order.email_queued = true
		order.expires_at   = Time.now + shop.brand.days_to_post.days + Rails.configuration.offer_email_delay
		order.save
	end


end