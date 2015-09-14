class CallbacksController < ApplicationController
	include Devise::Controllers::Rememberable
	skip_before_action :verify_authenticity_token, only: [:post, :webhook]


	def bigcommerce

		@brand = Brand.from_bc_omniauth(auth)

		shop = Shop.from_bc_omniauth(auth, @brand.id)

		if shop.present?
			SubscribeToOrdersWorker.perform_async(shop.token, shop.store_hash)
		end

		if @brand.persisted?
			remember_me(@brand)
		end

		redirect_to instagram_auth_path

	end

	def webhook
		render status: :ok

	end

	def load
		if params[:signed_payload].present?
			payload = parse_signed_payload

			current_store_hash = payload[:store_hash]

			@store = Store.find_by store_hash: current_store_hash

			remember_me(@shop.brand)

		else
			redirect_to denied_request_path
			flash[:notice] = "How'd you get here? You must not be logging in through Bigcommerce..."
		end

		redirect_to dashboard_path
	end



	#Subscribe to Shopper's Instagram
	def post
		case request.method
		when "GET"
			render text: params['hub.challenge']
		when "POST"
			binding.pry
			new_posts = params["_json"] || [] # need to parse the json?

			#do all logic after getting all data from instagram
			new_posts.each do |new_post|
				NewPostWorker.perform_async(new_post)
			end

			render nothing: true

		end
	end

	#handle Instagram Auth (both shopper & brand)
	def instagram
		binding.pry
		email = extras["email"]

		if extras["type"] == "shopper"
			#Make sure no one tries to add an email address in the url
			if Shopper.where(email: email).blank?

				shopper = Shopper.from_ig_omniauth(auth, extras)

				if shopper.present?
					SubscribeToShopperWorker.perform_async(shopper.token)
					redirect_to thank_you_authorized_shopper_path

					#this should never happen, but just in case
				else
					flash[:notice] = "You were not registered correctly. Try again"
					redirect_to denied_request_path
				end
			else
				flash[:notice] = "That email is already taken and you knew it!"
				redirect_to denied_request_path
			end
		elsif extras["type"] == "brand"

			current_brand.add_instagram_info(auth)

		else
			flash[:notice] = "You're not a brand OR a shopper...?"
			redirect_to denied_request_path
		end
	end


	private
	def auth
		request.env["omniauth.auth"]
	end
	def extras
		request.env["omniauth.params"]
	end

	def parse_signed_payload
		signed_payload = params[:signed_payload]
		message_parts = signed_payload.split('.')

		encoded_json_payload = message_parts[0]
		encoded_hmac_signature = message_parts[1]

		payload = Base64.decode64(encoded_json_payload)
		provided_signature = Base64.decode64(encoded_hmac_signature)

		expected_signature = sign_payload(ENV['BC_CLIENT_SECRET'], payload)

		if secure_compare(expected_signature, provided_signature)
			return JSON.parse(payload, symbolize_names: true)
		end

		nil
	end

	# Sign payload string using HMAC-SHA256 with given secret
	def sign_payload(secret, payload)
		OpenSSL::HMAC::hexdigest('sha256', secret, payload)
	end

	# Time consistent string comparison. Most library implementations
	# will fail fast allowing timing attacks.
	def secure_compare(a, b)
		return false if a.blank? || b.blank? || a.bytesize != b.bytesize
		l = a.unpack "C#{a.bytesize}"

		res = 0
		b.each_byte { |byte| res |= byte ^ l.shift }
		res == 0
	end

end