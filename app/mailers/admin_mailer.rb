class AdminMailer < ApplicationMailer
	default from: 'Errors@GramercyApp.com'

	def error_email(error)
		@error = error

		mail to: "admin@gramercyapp.com", subject: "There's been an error"
	end
end