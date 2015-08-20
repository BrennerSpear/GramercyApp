class ExpiresAtColumn < ActiveRecord::Migration
  def change
  	remove_column :orders, :days_to_post
  	add_column    :orders, :expires_at, :datetime
  end
end
