class AddRewardColumn < ActiveRecord::Migration
  def change
  	add_column :rewards, :code, :string
  end
end