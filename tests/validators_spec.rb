describe "Validators" do

  it "should add a global validator to ACL" do
    global_validator_name = "global_validator"
    ACL.add_global_validator(global_validator_name,lambda{return true})
    result = ACL.execute(global_validator_name)
    result.should be_true
  end

  it "should add some validators to ACL" do
    ACL.add_validator('validator', lambda{
      return some_arbitrary_value && hash_value == Hash.new
      })
    ACL.execute('validator').should be_true
  end
end