class Shoppers::OmniauthCallbacksController < Devise::OmniauthCallbacksController

	def instagram
		Shopper.from_omniauth(auth, extras)

		@shopper = Shopper.where(uid: auth.uid).first
		if @shopper.present?
			SubscribeToShopperWorker.perform_async(@shopper.token)
			redirect_to thank_you_authorized_shopper_path
		else
			flash[:notice] = "You were not registered correctly. Try again"
		end
	end

	def post
		flash[:notice] = "something with instagram worked"
	end


	# DDOS prevention for Instagram
	def challenge
		render text: params['hub.challenge']
	end

  private

	def auth
		request.env["omniauth.auth"]
	end

	def extras
		request.env["omniauth.params"]
	end

end