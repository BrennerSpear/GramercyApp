class Shop < ActiveRecord::Base

  	belongs_to :brand, inverse_of: :shop

	has_many   :orders
	has_many   :posts,   -> {uniq}, through: :orders, source: :post
    has_many   :rewards, -> {uniq}, through: :posts,  source: :reward


    def self.from_bc_omniauth(auth, brand_id)

    	shop = Shop.find_or_create_by(provider: auth.provider, uid: auth.uid) do |s|
    		s.brand_id		= brand_id
    		s.uid			= auth.uid
    		s.token			= auth.credentials.token.token
    		s.store_hash	= auth.extra.raw_info.context.split('/')[1]
    		s.save!
    	end

    	#it seems they switch the token (maybe when you uninstall?) so we have to always update
    	shop.token = auth.credentials.token.token

    	shop
    end

end
