class ChangeRewardColumn < ActiveRecord::Migration
  def change
  	change_column :rewards, :payable_total, :string, null: true
  end
end