class AddIndexToShoppers < ActiveRecord::Migration
  def change
  	remove_index :shoppers, :uid
    add_index :shoppers, :uid, unique: true
  end
end
