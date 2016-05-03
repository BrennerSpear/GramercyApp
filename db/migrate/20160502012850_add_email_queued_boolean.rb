class AddEmailQueuedBoolean < ActiveRecord::Migration
  def change
  	add_column :orders, :email_queued, :boolean, default: false
  end
end