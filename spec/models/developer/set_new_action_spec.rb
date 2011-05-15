require 'spec_helper'

describe Developer, :set_new_action do
  
  it "returns nil if the developer isn't found" do
    Developer.set_new_action('invalid@email.com').should be_nil
  end
  
  it "Sets a new action for the developer" do
    Id.stub!(:new).and_return("abctheid")
    expected = Factory.create(:developer, {:email => 'goku@dbz.org'})
    actual = Developer.set_new_action('goku@dbz.org')
    actual.should == expected
    actual.action.should == "abctheid"
    Developer.count({:_id => actual.id, :action => 'abctheid'}).should == 1 
  end

end