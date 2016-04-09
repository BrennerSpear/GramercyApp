class AddCurrentlyInstalledBoolean < ActiveRecord::Migration
  def change
  	add_column :shops, :currently_installed, :boolean, default: true
  end
end