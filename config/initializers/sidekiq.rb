require 'sidekiq/web'

Sidekiq.configure_server do |config|
	ActiveRecord::Base.configurations[Rails.env.to_s]['pool'] = 5
end

if Rails.env.production?
	 Sidekiq.configure_server do |config|
	 config.redis = { url: ENV["REDISTOGO_URL"], network_timeout: 5}
	end
	Sidekiq.configure_client do |config|
	 config.redis = { url: ENV["REDISTOGO_URL"], network_timeout: 5}
	end
end