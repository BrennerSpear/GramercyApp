class RemoveNotNullables < ActiveRecord::Migration
  def change
  	change_column :posts, :followers_generated, :integer, :null => true
  	change_column :posts, :likes, :integer, :null => true
  end
end
