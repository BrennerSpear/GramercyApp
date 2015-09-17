require 'test_helper'

class InstagramCallbacksControllerTest < ActionController::TestCase

	single_ig_subscription_post =
	{"_json"=>
		[
			{"changed_aspect"=>"media", "object"=>"user", "object_id"=>"2023726450", "time"=>1442270884, "subscription_id"=>19518183,"data"=>{"media_id"=>"1074168490087590938_2023726450"}
			}
		],
		"instagram_callback"=>
		{"_json"=>
			[
				{"changed_aspect"=>"media", "object"=>"user", "object_id"=>"2023726450", "time"=>1442270884, "subscription_id"=>19518183, "data"=>{"media_id"=>"1074168490087590938_2023726450"}
				}
			]
		}
	}

	double_ig_subscription_post =
	{"_json"=>
		[
			{"changed_aspect"=>"media", "object"=>"user", "object_id"=>"2023726450", "time"=>1442270884, "subscription_id"=>19518183,"data"=>{"media_id"=>"1074168490087590938_2023726450"}
			},
			{"changed_aspect"=>"media", "object"=>"user", "object_id"=>"2", "time"=>1442270884, "subscription_id"=>19518183,"data"=>{"media_id"=>"2"}
			}
		],
		"instagram_callback"=>
		{"_json"=>
			[
				{"changed_aspect"=>"media", "object"=>"user", "object_id"=>"2023726450", "time"=>1442270884, "subscription_id"=>19518183, "data"=>{"media_id"=>"1074168490087590938_2023726450"}
				},
				{"changed_aspect"=>"media", "object"=>"user", "object_id"=>"2", "time"=>1442270884, "subscription_id"=>19518183, "data"=>{"media_id"=>"2"}
				}
			]
		}
	}


	test "returns challenge to IG" do
		get :challenge, {"hub.challenge": "foobar_challenge"}

		assert_response :success
		assert_equal "foobar_challenge", @response.body

	end

	test "should send new IG post to NewPostWorker" do
		post :subscribe, {"_json": single_ig_subscription_post["_json"]}

		assert_response :success
	end

	test "should send two new IG post to NewPostWorker" do
		post :subscribe, {"_json": double_ig_subscription_post["_json"]}

		assert_response :success
	end

end
