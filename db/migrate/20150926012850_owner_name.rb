class OwnerName < ActiveRecord::Migration
  def change
  	rename_column :brands, :name, :owners_name
  	add_column :brands, :name, :string
  end
end