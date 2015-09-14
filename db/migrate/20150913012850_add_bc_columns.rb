class AddBcColumns < ActiveRecord::Migration
  def change
  	add_column :shops, :provider,   :string
  	add_column :shops, :uid,	    :string
  	add_column :shops, :token,	    :string
  	add_column :shops, :store_hash, :string
  	add_column :shops, :stripe_id,  :string
  end
end