class BrandsController < ApplicationController

	def dashboard

		if current_brand.nil?
			redirect_to home_path

		elsif current_brand.uid.nil?
			redirect_to instagram_auth_path

		elsif current_brand.cents_per_like.nil?
			redirect_to initial_settings_path

		elsif current_brand.shop.stripe_id.nil?
			redirect_to set_up_stripe_path
		else
				

			@brand       = current_brand
			@shop        = current_brand.shop
			@posts       = current_brand.posts
			@followers   = current_brand.followers

			#shoppers that have ordered from this store
			@shoppers = Shopper.joins(:orders).where(orders: {shop_id: @shop.id}).uniq

			#shoppers that have ordered from this store that have auth'd their IG
			@auth_shoppers = @shoppers.where('shoppers.uid IS NOT NULL')


			@total_likes = 0
			@total_new_follows = 0

			@posts.each do |p|
				@total_likes += p.likes
				@total_new_follows += p.followers_generated.count
			end

			#Set defaults
			@date_sort 	    = 'date_desc'
			@like_sort      = 'like_desc'
			@follower_sort  = 'follower_desc'
			@coupon_sort    = 'coupon_desc'
			@date_name	    = 'Date'
			@like_name 	    = 'Likes'
			@follower_name  = 'Followers Generated'
			@coupon_name    = 'Coupon Amount'
			@length_of_time = 'all_posts'

			# used for the graphs, which I can't get to work...
			# #get this brand's order ids
			# @order_ids = @orders.pluck(:id)

			# #shoppers that have ordered from this store that have auth'd their IG that have posted for this brand
			# @posters = @shoppers.joins(:posts).where(posts: {order_id: @order_ids})

			# @test = [
			# 	{period: '2010 Q1',
			# 		iphone: 10,
			# 		ipad: 20,
			# 	itouch: 30},
			# 	{period: '2010 Q2',
			# 		iphone: 20,
			# 		ipad: 50,
			# 	itouch: 100} ]

		end
	end

	def filter_dashboard
		@posts = current_brand.posts
		@followers = current_brand.followers

		#filter by date
		if params[:length_of_time] == "all_posts"
			@length_of_time = "all_posts"
		else
			@length_of_time = params[:length_of_time].to_i
			days = @length_of_time.days
			@posts = @posts.where("posts.created_at >= :date", date: (DateTime.now - days))
		end

		#Set defaults
		@date_sort 	    = 'date_desc'
		@like_sort      = 'like_desc'
		@follower_sort  = 'follower_desc'
		@coupon_sort    = 'coupon_desc'
		@date_name	    = 'Date'
		@like_name 	    = 'Likes'
		@follower_name  = 'Followers Generated'
		@coupon_name    = 'Coupon Amount'

		#calculate likes based on filtered posts
		@total_likes = 0
		@total_new_follows = 0

		@posts.each do |p|
			@total_likes += p.likes
			@total_new_follows += p.followers_generated.count
		end

		@shop = current_brand.shop
		#This doesn't change, but needs to be recalculated so it has a value
		@shoppers = Shopper.joins(:orders).where(orders: {shop_id: @shop.id}).uniq
		@auth_shoppers = @shoppers.where('shoppers.uid IS NOT NULL')

		respond_to do |format|
			format.js
		end

	end

	def sort_dashboard

		@posts = current_brand.posts
		@followers = current_brand.followers


		#Filter First
		if params[:length_of_time] == "all_posts"
			@length_of_time = "all_posts"
		else
			@length_of_time = params[:length_of_time].to_i
			days = @length_of_time.days
			@posts = @posts.where("posts.created_at >= :date", date: (DateTime.now - days))
		end

		@date_sort = 'date_desc'
		@like_sort = 'like_desc'
		@follower_sort = 'follower_desc'
		@coupon_sort	= 'coupon_desc'

		@date_name = 'Date'
		@like_name = 'Likes'
		@follower_name = 'Followers Generated'
		@coupon_name = 'Coupon Amount'

		case params[:name]

		when "date_desc"
			@posts = @posts.order(created_at: :desc)
			@date_sort = 'date_asc'
			@date_name = 'Date <i class="fa fa-sort-up"></i>'.html_safe

		when "date_asc"
			@posts = @posts.order(created_at: :asc)
			@date_sort = 'date_desc'
			@date_name = 'Date <i class="fa fa-sort-down"></i>'.html_safe

		when "like_desc"
			@posts = @posts.order(likes: :desc)
			@like_sort = 'like_asc'
			@like_name = 'Likes <i class="fa fa-sort-up"></i>'.html_safe

		when "like_asc"
			@posts = @posts.order(likes: :asc)
			@like_sort = 'like_desc'
			@like_name = 'Likes <i class="fa fa-sort-down"></i>'.html_safe

		when "follower_desc"
			@posts = @posts.select("posts.*, array_length(followers_generated, 1) AS f").order("f DESC")
			@follower_sort = 'follower_asc'
			@follower_name = 'Followers Generated <i class="fa fa-sort-up"></i>'.html_safe

		when "follower_asc"
			@posts = @posts.select("posts.*, array_length(followers_generated, 1) AS f").order("f ASC")
			@follower_sort = 'follower_desc'
			@follower_name = 'Followers Generated <i class="fa fa-sort-down"></i>'.html_safe

		when "coupon_desc"
			@posts = @posts.select('posts.*, payable_total').joins(:reward).order("payable_total DESC")
			@coupon_sort = 'coupon_asc'
			@coupon_name = 'Coupon Amount <i class="fa fa-sort-up"></i>'.html_safe

		when "coupon_asc"
			@posts = @posts.select('posts.*, payable_total').joins(:reward).order("payable_total ASC")
			@coupon_sort = 'coupon_desc'
			@coupon_name = 'Coupon Amount <i class="fa fa-sort-down"></i>'.html_safe

		end

		respond_to do |format|
			format.js
		end

	end


	def instagram_auth
		if current_brand.nil?
			redirect_to load_path
		elsif current_brand.uid.present?
			redirect_to initial_settings_path
		end

	end

	def initial_settings
		if current_brand.nil?
			redirect_to home_path
		elsif current_brand.uid.nil?
			flash[:notice] = "You haven't authorized your Brand's Instagram yet"
			redirect_to(:back)
		elsif current_brand.cents_per_like.present?
			redirect_to set_up_stripe_path
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
		if current_brand.nil?
			redirect_to home_path
		elsif current_brand.cents_per_like.nil?
			redirect_to initial_settings_path
		elsif current_brand.shop.stripe_id.present?
			redirect_to dashboard_path
		end
	end

	def send_stripe_info
		token = params[:stripeToken]
		desc  = " #{current_brand.name} (#{current_brand.nickname}) via #{current_brand.shop.provider}"
		email = current_brand.email

		begin
			customer = Stripe::Customer.create(
			card: 		 token,
			description: desc,
			email: 		 email
			)

			shop = current_brand.shop
			shop.stripe_id = customer.id
			shop.save!

		rescue Stripe::CardError => e

			flash[:notice] = e
			redirect_to set_up_stripe_path
		end

		redirect_to dashboard_path

	end

	def settings
		if current_brand.nil?
			redirect_to home_path
		end
	end

	def update_settings
		current_brand.add_settings_info(params)
		flash[:notice] = "Your Rates and Settings have been updated!"
		redirect_to dashboard_path
	end

end