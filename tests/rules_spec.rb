describe Vinyl::Rule do

  it "should add route to Vinyl. do
    Vinyl::when_route 'test', :with_method => 'POST', :get_access_level => 1, 
      :if_pass => ['validator']

    Vinyl.acl_routes_collection.should_not be_empty  
    Vinyl.acl_routes_collection.length.should == 1
  end

  it "should add multiple access level to route" do
    Vinyl::when_route 'test', :with_method => 'POST', :get_access_level => 1, 
      :if_pass => ['validator','bad_guy']
    Vinyl::when_route 'test', :with_method => 'POST', :get_access_level => 2, 
      :if_pass => ['validator']
    Vinyl::when_route 'test', :with_method => 'POST', :get_access_level => 3, 
      :if_pass => []
    
    Vinyl.acl_routes_collection['test'].should_not be_empty  
    Vinyl.acl_routes_collection.length.should == 1
    Vinyl.acl_routes_collection['test'].should include("POST")
    Vinyl.acl_routes_collection['test']['POST'].length.should == 3
  end

  it "should add a route with a non-existent validator" do
    Vinyl::when_route 'test', :with_method => 'GET', :get_access_level => 1, 
      :if_pass => ['fake_validator']
    Vinyl.acl_routes_collection['test'].should include("GET")
    Vinyl.acl_routes_collection['test']['GET'].length.should == 1
    Vinyl.execute('fake_validator').should be_false
  end
end
