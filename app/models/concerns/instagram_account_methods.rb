#Used for Brands & Shoppers

module InstagramAccountMethods
	extend ActiveSupport::Concern

	included do
		has_many :followed_bys, :as => :followable
		has_many :followers, :through => :followed_bys
	end

	def return_ig_client
		client = Instagram.client(access_token: self.token)
		client
	end

	def get_counts_and_return_ig_client
		client = self.return_ig_client

		self.media_count     = client.user.counts.media
		self.follower_count  = client.user.counts.followed_by
		self.following_count = client.user.counts.follows
		self.save!

		client
	end

	def initiate_getting_followers(type)
		client = self.get_counts_and_return_ig_client

		initial_page = client.user_followed_by
		get_more_followers(initial_page, client, type)
	end

	def get_more_followers(page, client, type)
		page.each do |f|

			begin
				#Create follower if it doesn't exist, but doesn't update it
				follower = Follower.where(uid: f["id"]).first_or_create(
				username: 		 f["username"],
				profile_picture: f["profile_picture"],
				name: 			 f["full_name"]
				)

				#Creates the follower-followable relation with timestamp
				FollowedBy.where(followable_id: self.id, follower_id: follower.id, followable_type: type).first_or_create

			rescue ActiveRecord::RecordNotUnique
				#Do nothing. by the powers of the universe, if the same IG account was being added
				#twice at the exact same time, you'd get this error
				#the index on uid protect this from actually happening
			end
		end

		#If another page exists, set cursor, get next page, recursively get the next page's followers
		unless page.pagination.next_cursor.nil?
			cursor = page.pagination.next_cursor
			next_page = client.user_followed_by(cursor: cursor)
			get_more_followers(next_page, client, type)
		end
	end
end