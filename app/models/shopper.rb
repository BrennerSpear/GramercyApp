class Shopper < ActiveRecord::Base
  include InstagramMethods

  has_many :posts
  has_many :rewards, -> {uniq}, through: :posts,  source: :reward
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :omniauthable, omniauth_providers: [:instagram]

  def self.from_omniauth(auth, extras)
      shopper = Shopper.find_or_create_by(provider: auth.provider, uid: auth.uid) do |s|
        s.password  = Devise.friendly_token[0,20]
        s.nickname  = auth.info.nickname
        s.name      = auth.info.name
        s.image     = auth.info.image
        s.website   = auth.info.website
        s.bio       = auth.info.bio
        s.token     = auth.credentials.token
        #DOTHIS add follower count, following count, media count
        s.save
      end

      #So shoppers can change their email address by 'signing up' again
      shopper.email = extras["email"]
      shopper.save!

      #get all followers only if there aren't any
      if shopper.followers.empty?
        InitiateGetFollowersWorker.perform_async(shopper.id, "Shopper")
      end
        
  end
end 