class AddOrderColumns < ActiveRecord::Migration
  def change

  	change_table (:orders) do |t|
  		t.belongs_to :shopper, index: true, null:false

		t.string :first_name
		t.string :last_name

		t.string :status
		t.datetime :date_shipped

		t.float :subtotal
		t.float :discount_amount
		t.float :coupon_amount
		t.float :store_credit_amount
		t.float :gift_certificate_amount
		t.float :total

		t.integer :item_count

		t.string :payment_method
		t.string :payment_status

		t.text :notes
		t.text :message
		t.string :source

		t.string :city
		t.string :state
		t.string :zipcode
		t.string :country
		t.string :country_code
		t.string :address_type
	end

	change_table (:shops) do |t|
		t.string :url
		t.string :plan
	end

	change_table (:shoppers) do |t|
		t.string :first_name
		t.string :last_name
		t.string :city
		t.string :state
		t.string :zipcode
		t.string :country
		t.string :country_code
		t.string :address_type
	end

  end
end
