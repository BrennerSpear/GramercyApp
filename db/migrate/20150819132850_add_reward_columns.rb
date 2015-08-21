class AddRewardColumns < ActiveRecord::Migration
  def change

	add_column	:rewards, :followers_generated, :integer
	add_column	:rewards, :likes, 				:integer
	add_column	:rewards, :cents_per_like,	    :integer
	add_column	:rewards, :dollars_per_follow, 	:float
	add_column	:rewards, :max_total_allowed , 	:float
  end
end
