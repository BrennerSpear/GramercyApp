class FixNullsAndDefaults < ActiveRecord::Migration
  def change
  	
  	change_column :brands, :follower_count, :string, default: 0, null: false
  	change_column :brands, :following_count, :string, default: 0, null: false
  	change_column :brands, :media_count, :string, default: 0, null: false

  	change_column :followed_bys, :followable_id, :integer, null: false
  	change_column :followed_bys, :follower_id, :integer, null: false
  	change_column :followed_bys, :followable_type, :string, null: false

  	change_column :followers, :uid, :string, null: false

  	change_column :orders, :expires_at, :datetime, null: false

  	change_column :posts, :likes, :integer, default: 0, null: false

  	change_column :shoppers, :follower_count, :string, default: 0, null: false
  	change_column :shoppers, :following_count, :string, default: 0, null: false
  	change_column :shoppers, :media_count, :string, default: 0, null: false

  end
end
