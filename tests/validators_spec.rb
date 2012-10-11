describe "Validators" do

  it "should add some validators to ACL" do
    ACL.add_validator('validator', lambda{
      return some_arbitrary_value && hash_value == Hash.new
      })
    ACL.execute('validator').should be_true
    ACL.add_validator('bad_guy', lambda{
      return false
      })
    ACL.execute('bad_guy').should be_false
  end
end