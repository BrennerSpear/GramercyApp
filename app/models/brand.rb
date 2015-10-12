class Brand < ActiveRecord::Base
	include InstagramAccountMethods

	has_one  :shop, inverse_of: :brand
	has_many :orders,  -> {uniq}, through: :shop,  source: :orders
	has_many :posts,   -> {uniq}, through: :orders, source: :post
	has_many :rewards, -> {uniq}, through: :posts,  source: :reward

	# Include default devise modules. Others available are:
	# :confirmable, :lockable, :timeoutable and :omniauthable
	devise :database_authenticatable, :async, :registerable,
	:recoverable, :rememberable, :trackable, :validatable

	def self.from_bc_omniauth(auth)

		brand = Brand.find_or_create_by(email: auth.info.email) do |b|
			b.password 	  = Devise.friendly_token[0,20]
			b.owners_name = auth.info.name
			b.save!
		end

		brand
	end

	def add_instagram_info(auth)
		self.nickname = auth.info.nickname
		self.image	  = auth.info.image
		self.bio	  = auth.info.bio
		self.website  = auth.info.website
		self.token 	  = auth.credentials.token
		self.uid	  = auth.uid
		self.save!

		if self.followers.empty?
			InitiateGetFollowersWorker.perform_async(self.id, "Brand")
		end

		self

	end

	def add_settings_info(params)
		self.cents_per_like		 = params[:brand][:cents_per_like]
		self.dollars_per_follow  = params[:brand][:dollars_per_follow]
		self.max_total_allowed	 = params[:brand][:max_total_allowed]
		self.days_to_post 		 = params[:brand][:days_to_post]
		self.save!
 	
 	end

	def get_active_posts_shoppers
		posts = self.posts.where('posts.created_at > :three_days_ago',
		three_days_ago: Time.now - Rails.configuration.expire_time)

		active_posts_shoppers = []

		posts.each do |p|

			shopper = Shopper.find(p.shopper_id)

			shopper.update_followers

			active_posts_shoppers << p.shopper_id
		end

		active_posts_shoppers
	end

	def update_followers(post_id)
		client = self.get_counts_and_return_ig_client

		initial_page = client.user_followed_by

		#post that initiated update by expiring
		post = Post.find(post_id)

		active_posts_shoppers = self.get_active_posts_shoppers

		#checks deeper for accounts with more followers
		follower_count = self.follower_count.to_i
		max_count = 3
		case
		when follower_count < 10000
			max_count = 3
		when follower_count < 100000
			max_count = 6
		when follower_count < 1000000
			max_count = 12
		when follower_count < 10000000
			max_count = 24
		when follower_count >=10000000
			max_count = 48
		end

		self.check_and_add_followers(initial_page, client, post, active_posts_shoppers, 0, max_count)
	end

	def check_and_add_followers(page, client, post, active_posts_shoppers, count, max_count)
		page.each do |newFollower|

			follower = Follower.where(uid: newFollower["id"]).first_or_create do |f|
				f.username        = newFollower["username"]
				f.profile_picture = newFollower["profile_picture"]
				f.name            = newFollower["full_name"]
				f.save!
			end

			#check if another post will take credit for the follower when it expires
			dont_save_follower = false
			active_posts_shoppers.each do |shopper_id|
				if FollowedBy.exists?(followable_id: shopper_id, follower_id: follower.id)
					dont_save_follower = true
				end
			end

			#if they already follow the brand, skip it
			if FollowedBy.exists?(followable_id: self.id, follower_id: follower.id, follower_type: "Brand")
				count += 1
				#if they don't follow the brand & follows the shopper that posted, attribute the follower
			elsif FollowedBy.exists?(followable_id: post.shopper.id, follower_id: follower.id, followable_type: "Shopper")
				count = 0
				FollowedBy.where(followable_id: self.id, follower_id: follower.id, followable_type: "Brand").first_or_create do |fb|
					post.followers_generated << follower.id
					post.save!
				end
				#if they don't follow the brand & follower the shopper of a different active post, do nothing
			elsif dont_save_follower
				count = 0
				#Do Nothing
				#if they don't follow the brand & don't follow any active post's shopper,
				#add the follower but don't attribute
			else
				count = 0
				#Creates the follower - brand with no attribution, a free follower!
				FollowedBy.where(followable_id: self.id, follower_id: follower.id, followable_type: "Brand").first_or_create do |fb|
				end
			end

			#Stop checking followers if we hit the max_count
			break if count > max_count

		end

		#If another page exists, and we haven't hit the count
		#set cursor, get next page, recursively get the next page's followers
		unless page.pagination.next_cursor.nil? || (count > max_count)
			cursor = page.pagination.next_cursor
			next_page = client.user_followed_by(cursor: cursor)
			self.check_and_add_followers(next_page, client, post, active_posts_shoppers, count, max_count)
		end
	end

end
