# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )
Rails.application.config.assets.precompile += %w( custom_home.js )
Rails.application.config.assets.precompile += %w( pages.css )
Rails.application.config.assets.precompile += %w( home.css )
Rails.application.config.assets.precompile += %w( payment_model.css )
Rails.application.config.assets.precompile += %w( benefits.css )
Rails.application.config.assets.precompile += %w( platforms.css )
Rails.application.config.assets.precompile += %w( faq.css )
Rails.application.config.assets.precompile += %w( privacy_policy.css )
Rails.application.config.assets.precompile += %w( terms_of_service.css )
Rails.application.config.assets.precompile += %w( thank_you.css )