class LeadMailer < ApplicationMailer
	default from: 'blspear@gmail.com'

	def sign_up_platform_exists(lead_id)
		@lead = Lead.find(lead_id)

		mail to: @lead.email, subject: "Invitation to Gramercy"
	end

	def sign_up_platform_does_not_exist(lead_id)
	  	@lead = Lead.find(lead_id)
	    
	    mail to: @lead.email, subject: "Invitation to Gramercy"
	end

	def sign_up_platform_custom(lead_id)
	  	@lead = Lead.find(lead_id)
	    
	    mail to: @lead.email, subject: "Invitation to Gramercy"
	end
end