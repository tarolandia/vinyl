ENV['RACK_ENV'] = "test"
require 'bundler/setup'
#require 'rack/test'

require 'vinyl'

RSpec.configure do |config|
  #config.include Rack::Test::Methods
end

Vinyl::configure do |config|
  config.api_acl_mode = Vinyl::Configuration::STRATEGY_DESCENDING
  config.force_access_control = true #Deny access if no validators are given for a route/method combination and no global validators exist
  config.warn_on_missing_validators = false
end
