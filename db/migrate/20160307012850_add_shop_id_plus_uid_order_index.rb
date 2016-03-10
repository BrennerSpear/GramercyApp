class AddShopIdPlusUidOrderIndex < ActiveRecord::Migration
  def change
  	add_index :orders, [:uid, :shop_id], unique: true
  end
end