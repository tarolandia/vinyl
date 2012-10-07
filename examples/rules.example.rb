require 'api-acl'

class MyRule 
  include ACL::Rules::Collection
  when_route 'test', :with_method => 'POST', :get_access_level => 1, :if_pass => ['User.test1']
  when_route 'test', :with_method => 'POST', :get_access_level => 2, :if_pass => ['User.test2', 'asd']
  when_route 'test', :with_method => 'GET', :get_access_level => 1, :if_pass => ['Test.1']
  when_route 'test', :with_method => 'GET', :get_access_level => 2, :if_pass => []
end


puts MyRule.acl_routes_collection
