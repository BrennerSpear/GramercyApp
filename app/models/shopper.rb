class Shopper < ActiveRecord::Base
  include InstagramAccountMethods

  has_many :posts
  has_many :orders
  has_many :rewards, -> {uniq}, through: :posts,  source: :reward

  # These two are in the InstagramAccountMethods
  # has_many :followed_bys, :as => :followable
  # has_many :followers, :through => :followed_bys

  devise :database_authenticatable, :async

  def self.from_bc_order(customer_address, email)
    shopper = Shopper.find_or_create_by(email: email)

    shopper.tap do |s|
      s.password     = Devise.friendly_token[0,20]
      s.first_name   = customer_address.first_name
      s.last_name    = customer_address.last_name
      s.city         = customer_address.city
      s.state        = customer_address.state
      s.zipcode      = customer_address.zip
      s.country      = customer_address.country
      s.country_code = customer_address.country_iso2
      s.address_type = customer_address.address_type
      s.save!
    end

    shopper
  end

  def self.from_ig_omniauth(auth, extras)
    

    #if they've auth'd via IG...
    shopper = Shopper.find_by_uid(auth.uid)

    if shopper.present?
      #...allow update of email address
      shopper.email = extras["email"].downcase
      shopper.save!
    else
      #if they haven't IG Auth'd, find their email if they've ordered using it, and connect IG
      shopper = Shopper.find_by(email: extras["email"].downcase)

      shopper.tap do |s|
        s.uid       = auth.uid
        s.provider  = auth.provider
        s.password  = Devise.friendly_token[0,20]
        s.nickname  = auth.info.nickname
        s.name      = auth.info.name
        s.image     = auth.info.image
        s.website   = auth.info.website
        s.bio       = auth.info.bio
        s.token     = auth.credentials.token
        s.save!
      end
    end

    #get all followers only if there aren't any
    if shopper.followers.empty?
      InitiateGetFollowersWorker.perform_async(shopper.id, "Shopper")
    end

    shopper
  end


  def update_followers
    client = self.get_counts_and_return_ig_client
    
    initial_page = client.user_followed_by

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

    self.check_and_add_followers(initial_page, client, 0, max_count)
  end

  def check_and_add_followers(page, client, count, max_count)
    page.each do |f|

      follower = Follower.where(uid: f["id"]).first_or_create do |p|
        p.username        = f["username"]
        p.profile_picture = f["profile_picture"]
        p.name            = f["full_name"]
        p.save!
      end

      #check if these are followers we already know about
      if FollowedBy.exists?(followable_id: self.id, follower_id: follower.id)
        count += 1
      else
        count = 0
        #Creates the follower - followable relation with timestamp
        FollowedBy.where(followable_id: self.id, follower_id: follower.id, followable_type: "Shopper").first_or_create do |p|
          p.followable_type = "Shopper"
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
      self.check_and_add_followers(next_page, client, count, max_count)
    end
  end

end








