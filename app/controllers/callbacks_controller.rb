class CallbacksController < ApplicationController

	def post
		case request.method
		when "GET"		
			render text: params['hub.challenge']
		when "POST"
			flash[:notice] = "something with instagram worked"
			render nothing: true
		end
	end

end

