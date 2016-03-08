require 'rails_helper'

RSpec.describe Brand, type: :model do
	it "has a valid factory" do
  		valid_brand = create(:brand)
    	expect(valid_brand).to be_valid
 	end
	it "is invalid without a media_count" do
  		invalid_brand = build(:brand, :media_count_nil)
    	expect(invalid_brand).to_not be_valid
	end
	it "is invalid without a password"
	it "is invalid without a follower_count"
	it "is invalid without a following_count"

end