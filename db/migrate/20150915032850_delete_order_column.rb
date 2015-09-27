class DeleteOrderColumn < ActiveRecord::Migration
  def change
  	remove_column :orders, :address_type
  end
end