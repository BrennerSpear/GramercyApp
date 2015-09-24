class ShoppersController < ApplicationController

	def shopper_sign_up
	end

	def shopper_signup_email
		if Shopper.where(email: params[:email]).blank?

			ShopperMailer.delay.prelaunch_signup(params[:email])
			redirect_to thank_you_shopper_path

		else
			redirect_to(:back)
			flash[:notice] = "You've already registered that email address to Gramercy"
		end
	end
end