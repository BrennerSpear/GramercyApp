

Rack::Timeout.unregister_state_change_observer(:logger) if Rails.env.development?
Rack::Timeout.timeout = 100000							if Rails.env.development?
