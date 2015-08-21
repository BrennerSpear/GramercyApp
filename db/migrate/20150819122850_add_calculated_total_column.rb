class AddCalculatedTotalColumn < ActiveRecord::Migration
  def change
  	rename_column	:rewards, :total, :payable_total
  	add_column		:rewards, :calculated_total, :float
  end
end
