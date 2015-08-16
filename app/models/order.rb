class Order < ActiveRecord::Base
	belongs_to :shop

	has_one    :post, -> { includes :shopper}
	has_many   :rewards, -> {uniq}, through: :posts,  source: :reward


end