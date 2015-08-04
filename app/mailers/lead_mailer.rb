class LeadMailer < ApplicationMailer
	default from: 'Admin@GramercyApp.com'

	def sign_up_platform_exists(lead_id)
		@lead = Lead.find(lead_id)

		mail to: @lead.email, subject: "Thanks for your Interest in Gramercy!"
	end

	def sign_up_platform_does_not_exist(lead_id)
	  	@lead = Lead.find(lead_id)
	    
	    mail to: @lead.email, subject: "Thanks for your Interest in Gramercy!"
	end

	def sign_up_platform_custom(lead_id)
	  	@lead = Lead.find(lead_id)
	    
	    mail to: @lead.email, subject: "Thanks for your Interest in Gramercy!"
	end
end