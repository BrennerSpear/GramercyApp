class CreateFollowerModels < ActiveRecord::Migration
	def change

	    add_column :shoppers, :follower_count, :string
	    add_column :shoppers, :following_count, :string
	    add_column :shoppers, :media_count, :string


    	add_column :brands, :uid, :string
    	add_index  :brands, :uid, unique: true
    	add_column :brands, :nickname, :string
    	add_column :brands, :name, :string
    	add_column :brands, :image, :string
    	add_column :brands, :bio, :string
    	add_column :brands, :website, :string
    	add_column :brands, :token, :string


		create_table (:followers) do |t|
			t.string :username
			t.string :profile_picture
			t.string :uid
			t.string :name
			t.timestamps null: false
		end

		create_table (:followed_bys) do |t|
			t.belongs_to :followable, polymorphic: true, index: true
			t.belongs_to :follower, index: true
			t.timestamps null: false
		end

		change_table (:shops) do |t|
			t.belongs_to :brand, index: true, null: false
		end

		create_table (:orders) do |t|
			t.belongs_to :shop, index: true, null: false

			t.integer :cents_per_like,    null: false
			t.float   :dollars_per_like,  null: false
			t.float   :max_total_allowed, null: false

			t.timestamps null: false

		end

		create_table (:posts) do |t|
			t.belongs_to :shopper, index: true, null: false
			t.belongs_to :order, index: true

			t.string  :type, 				null: false
			t.text    :caption
			t.string  :link,				null: false
			t.string  :image,				null: false
			t.string  :media_id,			null: false
			t.text    :tagged_accounts, array: true, default: []

			t.integer :followers_generated
			t.integer :likes

			t.timestamps null: false
		end

		create_table (:rewards) do |t|
			t.belongs_to :post, index: true, null: false
			t.float   :total,                null: false
			t.timestamps null: false
		end
	end
end