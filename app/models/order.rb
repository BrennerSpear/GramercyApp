class Order < ActiveRecord::Base
	belongs_to :shop

	has_one    :post, -> { includes :shopper}
	has_one    :reward, -> {uniq}, through: :post,  source: :reward


end