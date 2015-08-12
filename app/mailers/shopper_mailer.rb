class ShopperMailer < ApplicationMailer
	default from: 'Admin@GramercyApp.com'

	def prelaunch_signup(email)
		@email = email

		mail to: @email, subject: "Sign up with Gramercy"
	end
end
