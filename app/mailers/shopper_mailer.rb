class ShopperMailer < ApplicationMailer
	default from: 'Admin@GramercyApp.com'

	def prelaunch_signup(email)
		@email = email

		mail to: @email, subject: "Sign up with Gramercy"
	end

	def authorize_shopper_instagram(email, brand_name, brand_ig, cpl, dpf, dtp, max_coupon)
		@email 		= email
		@brand_name = brand_name
		@brand_ig 	= brand_ig
		@cpl		= cpl
		@dpf 		= dpf
		@dtp 		= dtp
		@max_coupon = max_coupon

		mail to: @email, subject: "get store credit to #{brand_name}"		
	end

	def shopper_instagram_authorized(email, shopper_ig)
		@email 		= email
		@shopper_ig = shopper_ig

		mail to: @email, subject: "You're all set up with Gramercy!"
	end

	def offer_from_order(email, brand_name, brand_ig, cpl, dpf, dtp, max_coupon)
		@email 		= email
		@brand_name = brand_name
		@brand_ig 	= brand_ig
		@cpl		= cpl
		@dpf 		= dpf
		@dtp 		= dtp
		@max_coupon = max_coupon

		mail to: @email, subject: "get store credit to #{brand_name}"
	end

	def thanks_for_your_post(email, brand_name, shopper_ig, brand_ig, ig_link, ig_image)
		@email 		= email
		@brand_name	= brand_name
		@shopper_ig = shopper_ig
		@brand_ig 	= brand_ig
		@ig_link	= ig_link
		@ig_image	= ig_image

		mail to: @email, subject: "Thanks for the Instagram of #{brand_name}"
	end

	def coupon_code(email, brand_name, likes, cpl, followers_generated, dpf, ig_image, ig_link, code, payable_total)
		@email		   		 = email
		@brand_name	   		 = brand_name
		@likes 		   		 = likes
		@cpl   		   		 = cpl
		@followers_generated = followers_generated
		@dpf 		  		 = dpf
		@ig_image			 = ig_image
		@ig_link			 = ig_link
		@code 		   		 = code
		@payable_total 		 = payable_total

		mail to: @email, subject: ("Your coupon to #{brand_name} ($" + sprintf('%.2f' % @payable_total) + ")")
	end

	def coupon_code_hit_max(email, brand_name, likes, cpl, followers_generated, dpf, ig_image, ig_link, code, payable_total)
		@email		   		 = email
		@brand_name	  		 = brand_name
		@likes 		  		 = likes
		@cpl   		  		 = cpl
		@followers_generated = followers_generated
		@dpf 		 	   	 = dpf
		@ig_image			 = ig_image
		@ig_link			 = ig_link
		@code 		  		 = code
		@payable_total 		 = payable_total

		mail to: @email, subject: "Your coupon to #{brand_name} ($#{payable_total})"
	end

	def sorry_no_coupon(email, brand_name, ig_image, ig_link)
		@email		   		 = email
		@brand_name	   		 = brand_name
		@ig_image			 = ig_image
		@ig_link			 = ig_link

		mail to: @email, subject: "It looks like your instagram didn't get any likes =("
	end


end
