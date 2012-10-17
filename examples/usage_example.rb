require 'api-acl'
#Configuration:
ACL::configure do |config|
  config.api_acl_mode = ACL::Configuration::STRATEGY_DESCENDING
  config.force_access_control = true #Deny access if no validators are given for a route/method combination and no global validators exist
  config.warn_on_missing_validators = true #Display a warning on STDOUT when calling a missing validator
end

#Define variables
ACL::some_arbitrary_value = true

#Define some validators:
#Global
ACL.add_global_validator("global_validator",lambda{return true}) #Global validators are executed for every route
#
ACL::add_validator("validator",lambda{return some_arbitrary_value})
ACL::add_validator("another_validator",lambda{return false})

#Define routes
ACL::when_route 'test', :with_method => 'POST', :get_access_level => 1, :if_pass => ['validator']
ACL::when_route 'test', :with_method => 'POST', :get_access_level => 2, :if_pass => ['validator', 'another_validator']
ACL::when_route 'test', :with_method => 'GET', :get_access_level => 1, :if_pass => ['another_validator']
ACL::when_route 'test', :with_method => 'GET', :get_access_level => 2, :if_pass => []

access_level = ACL::check_level('test','POST')
puts access_level
access_level = ACL::check_level('test','GET')
puts access_level