class Post < ActiveRecord::Base
	belongs_to :shopper
	belongs_to :order
	has_one    :reward

	def self.from_live_update(shopper_id, media_id)
		media = media(shopper_id, media_id)


		Post.find_or_create_by(media_id: media_id) do |p|
			p.media_type = media["type"]
			p.caption	 = media["caption"]["text"]
			p.link		 = media["link"]
			p.image		 = media["images"]["standard_resolution"]["url"]

			media["users_in_photo"].each do |tag|
				p.tagged_accounts << tag["user"]["id"]
			end

			p.shopper_id = shopper_id
		end

	end


	def connect_to_order
		brand = nil
		shopper_email = self.shopper.email

		#finds the first brand that has an order from the shopper that posted
		#the order has to not already have a post connected to it
		self.tagged_accounts.each do |uid|
			if Brand.exists?(uid: uid) && self.order_id.nil?
				brand = Brand.find_by_uid(uid)

				#get all orders this shopper has made at this specific brand
				past_orders = brand.orders.where(email: shopper_email)
				
				# find an order without a post connected to it, if it exists
				past_orders.each do |order|
					if order.post.nil?
				self.order_id = order.id
					end
				end
			end
		end	
		self.save!
	end




	def self.client(shopper_id)
		shopper = Shopper.find_by_uid(shopper_id)
		client  = Instagram.client(access_token: shopper.token)
		client
	end

	def self.media(shopper_id, media_id)
		client = client(shopper_id)
		media  = client.media_item(media_id)
		media
	end



end