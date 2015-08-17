class CallbacksController < ApplicationController

	def post
		case request.method
		when "GET"		
			render text: params['hub.challenge']
		when "POST"
			new_posts = params["_json"] || []
			new_posts.each do |new_post|
				ReceiveNewPostWorker.perform_async(new_post)
			end
			render nothing: true
		end
	end

end

