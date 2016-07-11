module Api
	module V1
		class PostsController < ApplicationController
			before_action :authenticate_clientapp
			respond_to :json

			def index

			end

			def show


				brand       = Brand.find(params[:id])
				shop        = brand.shop
				posts       = brand.posts
				#followers   = brand.followers

				post_count = posts.count

				total_likes = 0
				total_new_follows = 0

				posts.each do |p|
				total_likes += p.likes
				total_new_follows += p.followers_generated.count
				end

				#shoppers that have ordered from this store
				relevant_shoppers = Shopper.joins(:orders).where(orders: {shop_id: shop.id}).uniq
				relevant_shoppers_count = relevant_shoppers.count

				#count of shoppers that have ordered from this store that have auth'd their IG
				auth_shoppers_count = relevant_shoppers.where('shoppers.uid IS NOT NULL').count

				object = {relevant_shoppers_count: relevant_shoppers_count,
							auth_shoppers_count: auth_shoppers_count,
							post_count: post_count,
							total_likes: total_likes,
							total_new_follows: total_new_follows}

				respond_with(object)
			end
		end
	end
end