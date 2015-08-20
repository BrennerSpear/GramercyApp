#Used for Brands & Shoppers

module InstagramAccountMethods
	extend ActiveSupport::Concern

	included do
		has_many :followed_bys, :as => :followable
		has_many :followers, :through => :followed_bys
	end

	def initiate_getting_followers(type)
		client = Instagram.client(access_token: self.token)

		initial_page = client.user_followed_by
		get_more_followers(initial_page, client, type)
	end

	def get_more_followers(page, client, type)
		page.each do |f|
			#Create follower if it doesn't exist, but doesn't update it
			follower = Follower.where(uid: f["id"]).first_or_create do |p|
				p.username        = f["username"]
				p.profile_picture = f["profile_picture"]
				p.name            = f["full_name"]
				p.save!
			end

			#Creates the follower - followable relation with timestamp
			FollowedBy.where(followable_id: self.id, follower_id: follower.id, followable_type: type).first_or_create do |p|
				p.save!
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