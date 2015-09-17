class DeleteOrderColumn < ActiveRecord::Migration
  def change
  	delete_column :orders, :address_type
  end
end