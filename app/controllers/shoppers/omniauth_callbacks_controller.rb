class Shoppers::OmniauthCallbacksController < Devise::OmniauthCallbacksController

	def instagram
		email = extras["email"]

		#Make sure no one tries to add an email address in the url
		if Shopper.where(email: email).blank?
			
			Shopper.from_omniauth(auth, extras)

			shopper = Shopper.where(uid: auth.uid).first

			#this should never happen, but just in case
			if shopper.present?
				SubscribeToShopperWorker.perform_async(shopper.token)
				redirect_to thank_you_authorized_shopper_path
				
			else
				flash[:notice] = "You were not registered correctly. Try again"
				redirect_to denied_request_path
			end
		else
			flash[:notice] = "That email is already taken and you knew it!"
			redirect_to denied_request_path	
		end

		
	end




	# # DDOS prevention for Instagram
	# def challenge
	# 	binding.pry
	# 	render text: params['hub.challenge']
	# end

  private

	def auth
		request.env["omniauth.auth"]
	end

	def extras
		request.env["omniauth.params"]
	end

end