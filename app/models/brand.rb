class Brand < ActiveRecord::Base
	include InstagramMethods

	has_one  :shop, inverse_of: :brand 
  	has_many :orders,  -> {uniq}, through: :shop,  source: :orders
  	has_many :posts,   -> {uniq}, through: :orders, source: :post
  	has_many :rewards, -> {uniq}, through: :posts,  source: :reward
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :async, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         
end
