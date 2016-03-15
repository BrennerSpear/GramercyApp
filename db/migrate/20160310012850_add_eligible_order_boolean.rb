class AddEligibleOrderBoolean < ActiveRecord::Migration
  def change
  	add_column :orders, :reward_eligible, :boolean, default: true
  end
end