class BrandsController < ApplicationController
	# before_action :authenticate_brand!

	def dashboard
		if current_brand.nil?
			redirect_to load_path

		elsif current_brand.uid.nil?
			redirect_to instagram_auth_path

		elsif current_brand.cents_per_like.nil?
			redirect_to initial_settings_path

		elsif current_brand.shop.stripe_id.nil?
			redirect_to initial_stripe_path
		end
	end

	def instagram_auth
		if current_brand.nil?
			redirect_to load_path
		end

	end

	def initial_settings
		if current_brand.uid.nil?
			flash[:notice] = "You haven't authorized your Brand's Instagram yet"
			redirect_to(:back)
		else
			redirect_to initial_settings_path
		end

	end

	def initialize_settings

		if current_brand.nil?
			redirect_to load_path
		end
		current_brand.add_settings_info(params)

		redirect_to set_up_stripe_path
	end

	def set_up_stripe
		
	end


	def dashboard_test
		@brand       = Brand.first
		@shop        = Brand.first.shop
		@orders      = Brand.first.orders
		@posts        = Brand.first.posts
		@rewards      = Brand.first.rewards
		@followers    = Brand.first.followers
	end

end