require 'spec_helper'

describe Developer, :find_by_action do
  
  it "returns nil if the developer isn't found" do
    developer = Factory.create(:developer, {:action => 'xyz'})
    Developer.find_by_action('blah').should be_nil
  end
  
  it "returns the found developer" do
    developer = Factory.create(:developer, {:action => 'abc123'})
    Developer.find_by_action('abc123').should == developer
  end
  
end