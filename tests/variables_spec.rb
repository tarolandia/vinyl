describe Vinyl::UserVariables do

  before do
    $string_variable = "Test string"
    $hash_variable = Hash.new
  end

  it "should define some variables and reset them all" do
    Vinyl.here_is_one_variable = "Some value"
    Vinyl.some_arbitrary_value = true
    Vinyl.string_value = $string_variable
    Vinyl.hash_value = $hash_variable
    Vinyl.controller.variables.length.should == 4
    Vinyl.reset_variables
    Vinyl.controller.variables.length.should == 0
  end

  it "should add some variables to be used by validators" do
    Vinyl.some_arbitrary_value = true
    Vinyl.string_value = $string_variable
    Vinyl.hash_value = $hash_variable
    Vinyl.controller.variables.length.should == 3
  end

  it "should be able to access to previous defined variables"  do
    Vinyl.some_arbitrary_value.should be_true
    Vinyl.string_value.should eq $string_variable
    Vinyl.hash_value.should == $hash_variable
  end

  it "should be able to assign and retrieve null values" do
    Vinyl.variable_im_setting_nil = nil
    Vinyl.variable_im_setting_nil.should be_nil
  end
end