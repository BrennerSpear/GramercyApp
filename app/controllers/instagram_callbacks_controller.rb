class InstagramCallbacksController < ApplicationController
	include Devise::Controllers::Rememberable
	skip_before_action :verify_authenticity_token, only: [:challenge, :receive_post]


	def instagram
		if extras["type"] == "Shopper"

			shopper = Shopper.from_ig_omniauth(auth, extras)

			if shopper.present?
				redirect_to thank_you_authorized_shopper_path

				#these else cases should never happen, but just in case
			else
				flash[:notice] = "You were not registered correctly. Try again"
				redirect_to denied_request_path
			end
		elsif extras["type"] == "Brand"

			current_brand.add_instagram_info(auth)
			
			render text: '<script type="text/javascript"> window.close() </script>'

		else
			flash[:notice] = "You're not a brand OR a shopper...?"
			redirect_to denied_request_path
		end
	end


	def challenge
		render text: params['hub.challenge']

	end


	def receive_post
		new_posts = params["_json"] || [] # need to parse the json?

		#do all logic after getting all data from instagram
		new_posts.each do |new_post|
			NewPostWorker.perform_async(new_post)
		end

		render nothing: true

	end

	private
	def auth
		request.env["omniauth.auth"]
	end
	def extras
		request.env["omniauth.params"]
	end
end
