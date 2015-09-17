class BigcommerceCallbacksController < ApplicationController
	include Devise::Controllers::Rememberable
	skip_before_action :verify_authenticity_token, only: [:receive_order]


	def bigcommerce

		@brand = Brand.from_bc_omniauth(auth)

		shop = Shop.from_bc_omniauth(auth, @brand.id)

		if shop.present?

			SubscribeToBcOrdersWorker.perform_async(shop.token, shop.store_hash)
			GetBcStoreInfoWorker.perform_async(shop.token, shop.store_hash)
		end

		if @brand.persisted?
			remember_me(@brand)
		end

		redirect_to instagram_auth_path

	end

	def receive_order		

		if params[:data][:type] == "order"
			case params[:scope]
			when "store/order/created"
				ReceiveNewBcOrderWorker.perform_async(params)
			when "store/order/updated"

			when "store/order/statusUpdated"

			else
			end

		end

		render nothing: true, status: :ok

	end

	def load
		if params[:signed_payload].present?
			payload = parse_signed_payload

			current_store_hash = payload[:store_hash]

			@shop = Shop.find_by(provider: "bigcommerce", store_hash: current_store_hash)

			remember_me(@shop.brand)

		else
			redirect_to denied_request_path
			flash[:notice] = "How'd you get here? You must not be logging in through Bigcommerce..."
		end

		redirect_to dashboard_path
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