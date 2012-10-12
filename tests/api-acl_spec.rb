describe "ACL Access control" do

  it "should deny access to non configured routes if force_access_control is enabled" do
    ACL::configure do |config|
      config.force_access_control = false
    end    
    access_level = ACL.check_level('fake_route','GET')
    access_level.should == 1
    ACL::configure do |config|
      config.force_access_control = true
    end    
    access_level = ACL.check_level('fake_route','GET')
    access_level.should == 0
  end

  it "should force access control in abscence of validators" do
    access_level = ACL.check_level('test','POST')
    access_level.should == 2
    ACL::configure do |config|
      config.force_access_control = false
    end    
    access_level = ACL.check_level('test','POST')
    access_level.should == 3
  end

  it "should add a global validator to ACL" do
    global_validator_name = "global_validator"
    ACL.add_global_validator(global_validator_name,lambda{return true})
    result = ACL.execute(global_validator_name)
    result.should be_true
  end

  it "should fail with global validator" do
    ACL::global_validator_return = false
    ACL.add_global_validator("global_validator_name2",lambda{return global_validator_return})
    access_level = ACL.check_level('test','POST')
    access_level.should == 0
  end
  
  it "should bypass global validator" do
    access_level = ACL.bypass("global_validator_name2").check_level('test','POST')
    access_level.should == 3
    access_level = ACL.check_level('test','POST')
    access_level.should == 0
    ACL::global_validator_return = true
  end
  
  it "should return grant access levels according to validators" do
    access_level = ACL.check_level('test','POST')
    access_level.should == 3
  end

  it "should deny access to routes with non-existent validators" do
    access_level = ACL.check_level('test','GET')
    access_level.should == 0
  end

  it "should deny access after changing strategy" do
    ACL::configure do |config|
      config.api_acl_mode = ACL::Configuration::STRATEGY_ASCENDING
    end
    access_level = ACL.check_level('test','POST')
    access_level.should == 0
  end
end
