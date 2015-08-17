class FixTypeColumn < ActiveRecord::Migration
  def change
  	rename_column :posts, :type, :media_type
  	add_column	  :orders, :email, :string
  end
end
