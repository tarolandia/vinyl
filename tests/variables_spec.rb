describe ACL::UserVariables do

  before do
    $string_variable = "Test string"
    $hash_variable = Hash.new
  end

  it "should define some variables and reset them all" do
    ACL.here_is_one_variable = "Some value"
    ACL.some_arbitrary_value = true
    ACL.string_value = $string_variable
    ACL.hash_value = $hash_variable
    ACL.controller.variables.length.should == 4
    ACL.reset_variables
    ACL.controller.variables.length.should == 0
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

  it "should be able to assign and retrieve null values" do
    ACL.variable_im_setting_nil = nil
    ACL.variable_im_setting_nil.should be_nil
  end
end