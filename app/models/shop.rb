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

        shop.save!

        shop
    end


    def add_bc_store_info
        self.config_bc_client

        info = Bigcommerce::StoreInfo.info

        self.tap do |s|
            s.url = info.domain
            s.plan = info.plan_name
            s.save!
        end
    end


    def config_bc_client
        Bigcommerce.configure do |config|
            config.store_hash   = self.store_hash
            config.client_id    = ENV['BC_CLIENT_ID']
            config.access_token = self.token
        end

    end


    def create_coupon(reward)
        self.config_bc_client

        if reward.likes == 1
            likes = " like & "
        else
            likes = " likes & "
        end
        if reward.followers_generated == 1
            f_g = " follower generated)"
        else
            f_g = " followers generated)"
        end

        coupon_name = reward.post.shopper.nickname + " via Gramercy (" + reward.likes.to_s + likes + reward.followers_generated.to_s + f_g

        code = SecureRandom.hex

        reward.code = code
        reward.save!

        Bigcommerce::Coupon.create(
            name: coupon_name,
            code: code,
            type: 'per_total_discount',
            amount: reward.payable_total,
            max_uses: 1,
            max_uses_per_customer: 1,
            enabled: true,
            applies_to: {
                entity: 'categories',
                ids: [0]
            }
            )
    end
end
