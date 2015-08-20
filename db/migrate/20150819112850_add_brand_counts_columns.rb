class AddBrandCountsColumns < ActiveRecord::Migration
	def change

	    add_column :brands, :follower_count, :string
	    add_column :brands, :following_count, :string
	    add_column :brands, :media_count, :string
	end
end