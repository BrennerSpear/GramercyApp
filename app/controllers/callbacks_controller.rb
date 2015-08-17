class CallbacksController < ApplicationController
	skip_before_action :verify_authenticity_token, only: [:post]
	
	def post
		case request.method
		when "GET"		
			render text: params['hub.challenge']
		when "POST"
			new_posts = params["_json"] || []
			new_posts.each do |new_post|
				NewPostWorker.perform_async(new_post)
			end
			render nothing: true
		end
	end

end

