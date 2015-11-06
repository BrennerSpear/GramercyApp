class AdminsController < ApplicationController
	before_action :authenticate_admin!

	def admin_dashboard
		@brands       = Brand.all
		@shops        = Shop.all
		@shoppers     = Shopper.all
		@orders       = Order.all
		@posts        = Post.all
		@rewards      = Reward.all
		@followers    = Follower.all
		@followed_bys = FollowedBy.all

	end

	def show_brand
		@brand = Brand.find(params["id"])
		@posts = @brand.posts
		@shop        = @brand.shop
		@followers   = @brand.followers

		#shoppers that have ordered from this store
		@shoppers = Shopper.joins(:orders).where(orders: {shop_id: @shop.id}).uniq

		#shoppers that have ordered from this store that have auth'd their IG
		@auth_shoppers = @shoppers.where('shoppers.uid IS NOT NULL')

		@total_likes = 0
		@total_new_follows = 0

		@posts.each do |p|

			#TODO
			#this needs to be scheduled, not done on all posts of that brand everytime they go to this page
			UpdatePostLikesWorker.perform_async(p.id)

			@total_likes += p.likes
			@total_new_follows += p.followers_generated.count
		end
	end

	def admin_dash_brands
		@brands = Brand.all
	end

	def admin_dash_followers
		# @followers = Follower.all
		# @followed_bys = FollowedBy.all
		# @shoppers = Shopper.all
		# @brands = Brand.all
	end

	def admin_dash_orders
		@orders = Order.all
	end

end