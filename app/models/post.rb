class Post < ActiveRecord::Base
	belongs_to :shopper
	belongs_to :order
	has_one    :reward

	def self.from_live_update(shopper_uid, media_id)
		media = media(shopper_uid, media_id)


		Post.find_or_create_by(media_id: media_id) do |p|
			p.media_type = media["type"]
			p.link		 = media["link"]
			p.image		 = media["images"]["standard_resolution"]["url"]
			p.likes 	 = 0

			if media["caption"].present?
				p.caption	 = media["caption"]["text"]
			end

			#get just uid instead of converting to id
			#some tagged_accounts might be friends - we don't have an ID for them
			#and it doesn't make sense to make a 'follower' ActiveRecord for them
			media["users_in_photo"].each do |tag|
				p.tagged_accounts << tag["user"]["id"]
			end

			p.shopper_id = Shopper.find_by_uid(shopper_uid).id
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
				#that is still eligble to get a reward
				#TODO TEST THIS
				past_orders = brand.orders.where('email = ? AND  expires_at > ? AND reward_eligible = ?', shopper_email, Time.now, true)
				
				# find an order without a post connected to it, if it exists
				# it will take the first one it finds, then break
				past_orders.each do |order|
					if order.post.nil?
						self.order_id = order.id

						#Email shopper, thanks for post, we're tracking
						ShopperMailer.delay.thanks_for_your_post(
							shopper_email,
							brand.name,
							self.shopper.nickname,
							brand.nickname,
							self.link,
							self.image)
					end
					break if order.post.nil?
				end
			end
		end	
		self.save!
	end

	def update_likes

		begin
		shopper_uid = self.shopper.uid
		media = Post.media(shopper_uid, self.media_id)
		self.likes = media["likes"]["count"].to_i
		self.save
		rescue Instagram::BadRequest
			e = "#{self.shopper.uid} needs to renew their access token"
			AdminMailer.delay.error_email(e)
			ShopperMailer.delay.renew_access_token(self.shopper.email)
		end

	rescue Timeout::Error
		flash[:notice] = "Instagram isn't responding - the like counts are probably off, for now"
	end



	def self.client(shopper_uid)
		shopper = Shopper.find_by_uid(shopper_uid)
		client  = Instagram.client(access_token: shopper.token)
		client
	end

	def self.media(shopper_uid, media_id)
		client = client(shopper_uid)
		media  = client.media_item(media_id)
		media
	end



end