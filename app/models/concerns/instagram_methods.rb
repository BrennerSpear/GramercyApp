#Used for Brands & Shoppers

module InstagramMethods
	extend ActiveSupport::Concern

	included do
		has_many :followed_bys, :as => :followable
  		has_many :followers, :through => :followed_bys
  	end


	module ClassMethods



	  def initiate_getting_followers(shopper, type)
	    client = Instagram.client(access_token: shopper.token)

	    initial_page = client.user_followed_by
	    get_more_followers(initial_page, client, shopper, type)
	  end

	  def get_more_followers(page, client, shopper, type)
	    page.each do |f|
	      #Create follower if it doesn't exist, but doesn't update it
	      follower = Follower.where(uid: f["id"]).first_or_create do |p|
	        p.username        = f["username"]
	        p.profile_picture = f["profile_picture"]
	        p.name            = f["full_name"]
	        p.save!
	      end

	      #Creates the follower - shopper relation with timestamp
	      FollowedBy.where(followable_id: shopper.id, follower_id: follower.id).first_or_create do |p|
	        p.followable_type = type
	        p.save!
	      end
	    end

	    #If another page exitsts, set cursor, get next page, recursively get the next page's followers
	    unless page.pagination.next_cursor.nil?
	      cursor = page.pagination.next_cursor
	      next_page = client.user_followed_by(cursor: cursor)
	      get_more_followers(next_page, client, shopper, type)
	    end
	  end


	  def client
	    @instagram_client ||= Instagram.client(access_token: token)
	  end

	  def media
	    client.user_media_feed
	  end

	  def user
	    client.user
	  end

	  def recent_media
	    client.user_recent_media
	  end
	end

end