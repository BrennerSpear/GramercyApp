class AddedIndices < ActiveRecord::Migration
  def change
  	add_index :posts, :created_at
  	add_index :orders, :created_at
  end
end
