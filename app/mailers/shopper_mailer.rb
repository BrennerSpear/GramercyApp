class ShopperMailer < ApplicationMailer
	default from: 'Admin@GramercyApp.com'

	def prelaunch_signup(email)
		@email = email

		mail to: @email, subject: "Sign up with Gramercy"
	end

	def authorize_shopper_instagram(email, brand_name, brand_ig, cpl, dpf, ttp, max_coupon)
		@email 		= email
		@brand_name = brand_name
		@brand_ig 	= brand_ig
		@cpl		= cpl
		@dpf 		= dpf
		@ttp 		= ttp
		@max_coupon = max_coupon

		mail to: @email, subject: "get store credit from #{brand_name}"		
	end

	def shopper_instagram_authorized(email, shopper_ig)
		@email 		= email
		@shopper_ig = shopper_ig

		mail to: @email, subject: "You're all set up!"
	end

	def offer_from_order(email, brand_name, brand_ig, cpl, dpf, ttp, max_coupon)
		@email 		= email
		@brand_name = brand_name
		@brand_ig 	= brand_ig
		@cpl		= cpl
		@dpf 		= dpf
		@ttp 		= ttp
		@max_coupon = max_coupon

		mail to: @email, subject: "get store credit from #{brand_name}"
	end

	def thanks_for_your_post(email, brand_name, shopper_ig, brand_ig, ig_link)
		@email 		= email
		@brand_name	= brand_name
		@shopper_ig = shopper_ig
		@brand_ig 	= brand_ig
		@ig_link	= ig_link

		mail to: @email, subject: "Thanks for the Instagram of #{brand_name}"
	end

	def coupon_code(email, brand_name, likes, cpl, new_followers, dpf, code)
		@email		   = email
		@brand_name	   = brand_name
		@likes 		   = likes
		@cpl   		   = cpl
		@new_followers = new_followers
		@dpf 		   = dpf
		@code 		   = code

		mail to: @email, subject: "Your coupon to #{brand_name} (#{total})"
	end

	def coupon_code_hit_max(email, brand_name, likes, cpl, new_followers, dpf, code, total)
		@email		   = email
		@brand_name	   = brand_name
		@likes 		   = likes
		@cpl   		   = cpl
		@new_followers = new_followers
		@dpf 		   = dpf
		@code 		   = code
		@total		   = total

		mail to: @email, subject: "Your coupon to #{brand_name} ($#{total})"
	end

end
