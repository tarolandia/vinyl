require 'api-acl'

ACL::when_route 'test', :with_method => 'POST', :get_access_level => 1, :if_pass => ['User.test1']
ACL::when_route 'test', :with_method => 'POST', :get_access_level => 2, :if_pass => ['User.test2', 'asd']
ACL::when_route 'test', :with_method => 'GET', :get_access_level => 1, :if_pass => ['Test.1']
ACL::when_route 'test', :with_method => 'GET', :get_access_level => 2, :if_pass => []

p ACL::acl_routes_collection