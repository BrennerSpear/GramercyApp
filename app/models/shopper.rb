class Shopper < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :omniauthable, omniauth_providers: [:instagram]


  def self.from_omniauth(auth, extras)
  		shopper = Shopper.find_or_create_by(provider: auth.provider, uid: auth.uid)
  		shopper.email 		= extras["email"]
  		shopper.password 	= Devise.friendly_token[0,20]
  		shopper.nickname 	= auth.info.nickname
  		shopper.name 	  	= auth.info.name
  		shopper.image 		= auth.info.image
  		shopper.website		= auth.info.website
      shopper.bio       = auth.info.bio
  		shopper.token 		= auth.credentials.token
  		shopper.save
  end

  def client
    @client ||= Instagram.client(access_token: token)
  end

  def followers
  end


end
