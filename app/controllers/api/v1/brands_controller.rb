module Api
	module V1
		class BrandsController < ApplicationController
			before_action :authenticate_clientapp
			respond_to :json


			def from_store_hash
				shop = Shop.find_by(provider: params[:provider], store_hash: params[:store_hash])

				brand = shop.brand

				object = {
					id: brand.id,
					email: brand.email,
					name: brand.name,
					uid: brand.uid,
					nickname: brand.nickname,
					owners_name: brand.owners_name,
					image: brand.image,
					bio: brand.bio,
					website: brand.website,
					cents_per_like: brand.cents_per_like,
					dollars_per_follow: brand.dollars_per_follow,
					days_to_post: brand.days_to_post,
					max_total_allowed: brand.max_total_allowed,
					follower_count: brand.follower_count,
					following_count: brand.following_count,
					media_count: brand.media_count
				}

				respond_with(object)
			end

			def info
				brand = Brand.find(params[:id])

				object = {
					id: brand.id,
					email: brand.email,
					name: brand.name,
					uid: brand.uid,
					nickname: brand.nickname,
					owners_name: brand.owners_name,
					image: brand.image,
					bio: brand.bio,
					website: brand.website,
					cents_per_like: brand.cents_per_like,
					dollars_per_follow: brand.dollars_per_follow,
					days_to_post: brand.days_to_post,
					max_total_allowed: brand.max_total_allowed,
					follower_count: brand.follower_count,
					following_count: brand.following_count,
					media_count: brand.media_count
				}

				respond_with(object)
			end

			def counts
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

			def update
			end

			def posts
			end



		end
	end
end