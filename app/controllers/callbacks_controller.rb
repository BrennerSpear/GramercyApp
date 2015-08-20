class CallbacksController < ApplicationController
	skip_before_action :verify_authenticity_token, only: [:post]
	
	def post
		case request.method
		when "GET"		
			render text: params['hub.challenge']
		when "POST"
			new_posts = []
			new_posts << params["_json"] || []

			render nothing: true

			new_posts_holder = []
			#not sure if this handles 2 json objects correctly....
			new_posts.each do |new_post|
				new_posts_holder << new_post
			end

			#do all logic after getting all data from instagram
			new_posts_holder.each do |new_post|
				NewPostWorker.perform_async(new_post)
			end
		end
	end

end

