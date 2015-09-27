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

end