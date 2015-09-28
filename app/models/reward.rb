class Reward < ActiveRecord::Base
	belongs_to :post

	def self.from_post(post_id)
		Reward.find_or_create_by(post_id: post_id) do |r|
			r.payable_total = 0
		end
	end

	#DOTHIS
	def calculate_total
		self.followers_generated = self.post.followers_generated.count
		self.likes 				 = self.post.likes
		self.cents_per_like		 = self.post.order.cents_per_like
		self.dollars_per_follow  = self.post.order.dollars_per_follow
		self.max_total_allowed   = self.post.order.max_total_allowed

		self.calculated_total = ((self.followers_generated * self.dollars_per_follow) + (self.likes * self.cents_per_like / 100.0))

		totals = []
		totals << self.calculated_total
		totals << self.max_total_allowed

		self.payable_total = totals.min.round(2)

		self.save
	end

end