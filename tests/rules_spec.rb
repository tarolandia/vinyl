require_relative 'spec_helper.rb'

describe ACL::Rule do

  it "should add route to ACL" do
    ACL::when_route 'test', :with_method => 'POST', :get_access_level => 1, 
      :if_pass => ['validator']

    ACL.acl_routes_collection.should_not be_empty  
    ACL.acl_routes_collection.length.should == 1
  end

  it "should add multiple access level to route" do
    ACL::when_route 'test', :with_method => 'POST', :get_access_level => 1, 
      :if_pass => ['validator']
    ACL::when_route 'test', :with_method => 'POST', :get_access_level => 2, 
      :if_pass => ['validator']
    
    ACL.acl_routes_collection['test'].should_not be_empty  
    ACL.acl_routes_collection.length.should == 1
    ACL.acl_routes_collection['test'].should include("POST")
    ACL.acl_routes_collection['test']['POST'].length.should == 2
  end

end
