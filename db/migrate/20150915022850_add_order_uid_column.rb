class AddOrderUidColumn < ActiveRecord::Migration
  def change
  	add_column :orders, :uid, :string
  end
end