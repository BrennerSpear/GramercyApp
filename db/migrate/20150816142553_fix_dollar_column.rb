class FixDollarColumn < ActiveRecord::Migration
  def change
  	rename_column	:orders, :dollars_per_like, :dollars_per_follow
  	add_column		:orders, :days_to_post, :integer
  	add_column		:brands, :cents_per_like, :integer
  	add_column		:brands, :dollars_per_follow, :float
  	add_column		:brands, :days_to_post, :integer
  	add_column		:brands, :max_total_allowed, :float	
  end
end
