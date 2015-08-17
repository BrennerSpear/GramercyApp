class Reward < ActiveRecord::Base
	belongs_to :post

	def self.from_post(post_id)
		Reward.find_or_create_by(post_id: post_id) do |r|
			r.total = 0
		end
	end

	#DOTHIS
	def update_total

	end
	
end