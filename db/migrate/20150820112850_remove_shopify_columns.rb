class RemoveShopifyColumns < ActiveRecord::Migration
  def change
  	remove_column :shops, :shopify_domain
  	remove_column :shops, :shopify_token
  end
end