class Shoppers::OmniauthCallbacksController < Devise::OmniauthCallbacksController

	def instagram
		@shopper = Shopper.from_omniauth(auth, extras)
		binding.pry
		if @shopper.present?
			redirect_to thank_you_authorized_shopper_path
		else
			flash[:notice] = "You were not registered correctly. Try again"
		end
	end



	def auth
		request.env["omniauth.auth"]
	end

	def extras
		request.env["omniauth.params"]
	end

end