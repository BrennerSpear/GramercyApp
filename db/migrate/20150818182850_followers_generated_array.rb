class FollowersGeneratedArray < ActiveRecord::Migration
  def change
  	remove_column :posts, :followers_generated

  	change_table (:posts) do |t|
		t.text    :followers_generated, array: true, default: []
	end
  end
end
