class ChangeExpiresAtColumn < ActiveRecord::Migration
  def change
  	change_column :orders, :expires_at, :datetime, null: true
  end
end