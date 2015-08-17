class Reward < ActiveRecord::Base
	belongs_to :post

	def self.from_post(post_id)
		p = Post.find_or_create_by(post_id: post_id)
		p.total = 0
		p.save!
	end

	#DOTHIS
	def update_total

	end
	
end