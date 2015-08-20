class ApplicationController < ActionController::Base
	include ShopifyApp::Controller
	# Prevent CSRF attacks by raising an exception.
	# For APIs, you may want to use :null_session instead.
	protect_from_forgery with: :exception

	helper_method :client, :media


	def client(shopper_uid)
		shopper = Shopper.find_by_uid(shopper_uid)
		client  = Instagram.client(access_token: shopper.token)
		client
	end

	def media(shopper_uid, media_id)
		client = client(shopper_uid)
		media  = client.media_item(media_id)
		media
	end




end