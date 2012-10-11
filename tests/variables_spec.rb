describe ACL::UserVariables do

  before do
    $string_variable = "Test string"
    $hash_variable = Hash.new
  end

  it "should add some variables to be used by validators" do
    ACL.some_arbitrary_value = true
    ACL.string_value = $string_variable
    ACL.hash_value = $hash_variable
    ACL.controller.variables.length.should == 3
  end

  it "should be able to access to previous defined variables"  do
    ACL.some_arbitrary_value.should be_true
    ACL.string_value.should eq $string_variable
    ACL.hash_value.should == $hash_variable
  end
end