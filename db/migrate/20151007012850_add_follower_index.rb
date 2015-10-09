class AddFollowerIndex < ActiveRecord::Migration
  def change
  	add_index :followers, :uid, unique: true
  end
end