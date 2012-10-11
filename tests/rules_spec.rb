describe ACL::Rule do

  it "should add route to ACL" do
    ACL::when_route 'test', :with_method => 'POST', :get_access_level => 1, 
      :if_pass => ['validator']

    ACL.acl_routes_collection.should_not be_empty  
    ACL.acl_routes_collection.length.should == 1
  end

  it "should add multiple access level to route" do
    ACL::when_route 'test', :with_method => 'POST', :get_access_level => 1, 
      :if_pass => ['validator','bad_guy']
    ACL::when_route 'test', :with_method => 'POST', :get_access_level => 2, 
      :if_pass => ['validator']
    ACL::when_route 'test', :with_method => 'POST', :get_access_level => 3, 
      :if_pass => []
    
    ACL.acl_routes_collection['test'].should_not be_empty  
    ACL.acl_routes_collection.length.should == 1
    ACL.acl_routes_collection['test'].should include("POST")
    ACL.acl_routes_collection['test']['POST'].length.should == 3
  end

  it "should add a route with a non-existent validator" do
    ACL::when_route 'test', :with_method => 'GET', :get_access_level => 1, 
      :if_pass => ['fake_validator']
    ACL.acl_routes_collection['test'].should include("GET")
    ACL.acl_routes_collection['test']['GET'].length.should == 1
    ACL.execute('fake_validator').should be_false
  end
end
