class Shop < ActiveRecord::Base
  include ShopifyApp::Shop

  	belongs_to :brand, inverse_of: :shop

	has_many   :orders
	has_many   :posts,   -> {uniq}, through: :orders, source: :post
    has_many   :rewards, -> {uniq}, through: :posts,  source: :reward

end
