# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!


if $0 =~ /(rake|railroady|erd)$/
  Rails.logger = Logger.new("/dev/null")
end