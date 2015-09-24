class ChangeRewardColumns < ActiveRecord::Migration
  def change
  	remove_index :rewards, :payable_total
  	execute 'ALTER TABLE rewards ALTER COLUMN payable_total TYPE float USING payable_total::float'
  end
end