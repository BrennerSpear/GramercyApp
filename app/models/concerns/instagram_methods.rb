#Used for Brands & Shoppers

module InstagramMethods
	extend ActiveSupport::Concern

	included do
		has_many :followed_bys, :as => :followable
  		has_many :followers, :through => :followed_bys
  	end


	module ClassMethods



	  def initiate_getting_followers(followable, type)
	    client = Instagram.client(access_token: followable.token)

	    initial_page = client.user_followed_by
	    get_more_followers(initial_page, client, followable, type)
	  end

	  def get_more_followers(page, client, followable, type)
	    page.each do |f|
	      #Create follower if it doesn't exist, but doesn't update it
	      follower = Follower.where(uid: f["id"]).first_or_create do |p|
	        p.username        = f["username"]
	        p.profile_picture = f["profile_picture"]
	        p.name            = f["full_name"]
	        p.save!
	      end

	      #Creates the follower - followable relation with timestamp
	      FollowedBy.where(followable_id: followable.id, follower_id: follower.id).first_or_create do |p|
	        p.followable_type = type
	        p.save!
	      end
	    end

	    #If another page exists, set cursor, get next page, recursively get the next page's followers
	    unless page.pagination.next_cursor.nil?
	      cursor = page.pagination.next_cursor
	      next_page = client.user_followed_by(cursor: cursor)
	      get_more_followers(next_page, client, followable, type)
	    end
	  end



	  def update_followers(followable, type)
	  	client = Instagram.client(access_token: followable.token)

	  	initial_page = client.user_followed_by

	  	#checks deeper for accounts with more followers
	  	follower_count = followable.follower_count.to_i
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

	    check_and_add_followers(initial_page, client, followable, type, 0, max_count)
	  end

	  def check_and_add_followers(page, client, followable, type, count, max_count)
	    page.each do |f|

	    	follower = Follower.where(uid: f["id"]).first_or_create do |p|
		        p.username        = f["username"]
		        p.profile_picture = f["profile_picture"]
		        p.name            = f["full_name"]
		        p.save!
	      	end

	      	#check if these are followers we already know about
	    	if FollowedBy.exists?(followable_id: followable.id, follower_id: follower.id)
	    		count += 1
	    	else
	    		count = 0
	    		#Creates the follower - followable relation with timestamp
	      		FollowedBy.where(followable_id: followable.id, follower_id: follower.id).first_or_create do |p|
	        		p.followable_type = type
	        		p.save!
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
	      get_more_followers(next_page, client, followable, type, count, max_count)
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