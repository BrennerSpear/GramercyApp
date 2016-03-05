require 'rails_helper'

RSpec.describe Brand, type: :model do
  it "has a valid factory" do
  	brand = create(:brand)
    expect(brand).to be_valid
  end
	it "is invalid without an email"
	it "is invalid without a password"
	it "is invalid without a follower_count"
	it "is invalid without a following_count"
	it "is invalid without a media_count"




end