require 'faker'

FactoryGirl.define do
	factory :brand do
		email {Faker::Internet.email}
		password {Faker::Internet.password}
		follower_count {Faker::Number.between(1, 100)}
		following_count {Faker::Number.between(1, 100)}
		media_count {Faker::Number.between(1, 100)}

		trait :media_count_nil do
			email {Faker::Internet.email}
			password {Faker::Internet.password}
			follower_count {Faker::Number.between(1, 100)}
			following_count {Faker::Number.between(1, 100)}
			media_count nil
		end

	end
end