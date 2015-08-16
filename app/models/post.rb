class Post < ActiveRecord::Base
	belongs_to :shopper
	belongs_to :order
	has_one    :reward

end