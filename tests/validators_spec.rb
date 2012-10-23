describe "Validators" do

  it "should add some validators to Vinyl" do
    Vinyl.add_validator('validator', lambda{
      return some_arbitrary_value && hash_value == Hash.new
      })
    Vinyl.execute('validator').should be_true
    Vinyl.add_validator('bad_guy', lambda{
      return false
      })
    Vinyl.execute('bad_guy').should be_false
  end

  it "should return nil if there has been defined a variable with nil value" do
    Vinyl.some_nil_variable = nil
    Vinyl::Validators.some_nil_variable.should be_nil
    Vinyl::Validators.non_set_value.should be_false
  end
end
