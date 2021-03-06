require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module GramercyApp
  class Application < Rails::Application
    config.eager_load = true
    config.action_dispatch.default_headers['P3P'] = 'CP="Not used"'
    config.action_dispatch.default_headers.delete('X-Frame-Options')
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true

    config.middleware.use Rack::Attack
    
    config.assets.paths << Rails.root.join('vendor', 'assets', 'components')

    config.expire_time = 3.days
    config.offer_email_delay = 5.days

    config.action_dispatch.default_headers = {'X-Frame-Options' => 'ALLOWALL'}

    # @TODO change this from * to just the frontend app's domain
    config.action_dispatch.default_headers.merge!({
        'Access-Control-Allow-Origin' => '*',
        'Access-Control-Request-Method' => '*'
        })

    config.middleware.insert_before 0, "Rack::Cors" do
      allow do
        origins '*'
        resource '*', :headers => :any, :methods => [:get, :post, :options]
      end
    end

    config.generators do |g|
        g.test_framework :rspec,
            fixtures: true,
            view_sepcs: false,
            helper_specs: false,
            routing_specs: false,
            controller_specs: true,
            request_specs: true
        g.fixture_replacement :factory_girl, dir: "spec/factories"
    end
    
  end
end
