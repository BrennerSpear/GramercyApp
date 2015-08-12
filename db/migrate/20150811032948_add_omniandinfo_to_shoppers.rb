class AddOmniandinfoToShoppers < ActiveRecord::Migration
  def change
    add_column :shoppers, :provider, :string
    add_index :shoppers, :provider
    add_column :shoppers, :uid, :string
    add_index :shoppers, :uid
    add_column :shoppers, :nickname, :string
    add_column :shoppers, :name, :string
    add_column :shoppers, :image, :string
    add_column :shoppers, :bio, :string
    add_column :shoppers, :website, :string
    add_column :shoppers, :token, :string
  end
end
