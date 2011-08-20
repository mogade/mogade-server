require 'spec_helper'
require 'bcrypt'

describe Developer, :find_by_email do
  
  it "returns nil if the email isn't valid" do
    Developer.find_by_email(nil).should be_nil
    Developer.find_by_email('').should be_nil
  end
  
  it "returns nil if the email isn't found" do
    FactoryGirl.create(:developer, {:email => 'leto@dune.gov'})
    Developer.find_by_email('paul@dune.gov').should be_nil
  end
  
  it "returns the found developer" do
    developer = FactoryGirl.create(:developer, {:email => 'ghanima@dune.gov'})
    Developer.find_by_email('ghanima@dune.gov').should == developer
  end
  
end