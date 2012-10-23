require 'vinyl'
#Configuration:
Vinyl::configure do |config|
  config.api_acl_mode = Vinyl::Configuration::STRATEGY_DESCENDING
  config.force_access_control = true #Deny access if no validators are given for a route/method combination and no global validators exist
  config.warn_on_missing_validators = true #Display a warning on STDOUT when calling a missing validator
end

#Clear previous registered variables
Vinyl::reset_variables
#Define variables
Vinyl::some_arbitrary_value = true

#Define some validators:
#Global
Vinyl.add_global_validator("global_validator",lambda{return true}) #Global validators are executed for every route
#
Vinyl::add_validator("validator",lambda{return some_arbitrary_value})
Vinyl::add_validator("another_validator",lambda{return false})

#Define routes
Vinyl::when_route 'test', :with_method => 'POST', :get_access_level => 1, :if_pass => ['validator']
Vinyl::when_route 'test', :with_method => 'POST', :get_access_level => 2, :if_pass => ['validator', 'another_validator']
Vinyl::when_route 'test', :with_method => 'GET', :get_access_level => 1, :if_pass => ['another_validator']
Vinyl::when_route 'test', :with_method => 'GET', :get_access_level => 2, :if_pass => []

access_level = Vinyl::check_level('test','POST')
puts access_level
access_level = Vinyl::check_level('test','GET')
puts access_level