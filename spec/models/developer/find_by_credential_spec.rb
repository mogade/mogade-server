require 'spec_helper'
require 'bcrypt'

describe Developer, :find_by_credential do
  
  it "returns nil if the email isn't valid" do
    Developer.find_by_credential(nil, 'password').should be_nil
    Developer.find_by_credential('', 'password').should be_nil
  end
  
  it "returns nil if the password isn't valid" do
    Developer.find_by_credential('a@a.com', nil).should be_nil
    Developer.find_by_credential('a@a.com', '').should be_nil
  end
  
  it "returns nil the password doesn't match" do
    FactoryGirl.create(:developer, {:email => 'leto@dune.gov'})
    Developer.find_by_credential('leto@dune.gov', 'spice').should be_nil
  end
  
  it "returns the found developer" do
    developer = FactoryGirl.create(:developer, {:email => 'leto@dune.gov', :password => BCrypt::Password.create('ghanima')})
    Developer.find_by_credential('leto@dune.gov', 'ghanima').should == developer
  end
  
end