class AdminMailer < ApplicationMailer
	default from: 'Errors@GramercyApp.com'

	def error_email(error)
		@error = error

		mail to: "admin@gramercyapp.com", subject: "There's been an error"
	end

	def uninstall_email(brand_name, provider, ineligible_order_count)
		@brand_name 			= brand_name
		@provider 				= provider
		@ineligible_order_count = ineligible_order_count

		mail to: "admin@gramercyapp.com", subject: "#{brand_name} uninstalled Gramercy from #{provider}"
	end
end