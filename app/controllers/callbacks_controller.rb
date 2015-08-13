class CallbacksController < ApplicationController

	def post

		render text: "TESTING"
		# case request.method
		# when "GET"
		# 	@challenge = params['hub.challenge']
		# 	render text: @challenge
		# when "POST"
		# 	flash[:notice] = "something with instagram worked"
		# 	render nothing: true
		# end
	end

end

