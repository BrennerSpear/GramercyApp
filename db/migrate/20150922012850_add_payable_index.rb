class AddPayableIndex < ActiveRecord::Migration
  def change
  	add_index :rewards, :payable_total, unique: false
  end
end