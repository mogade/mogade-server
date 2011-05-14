require 'spec_helper'
require 'bcrypt'

describe Signup, :to_developer do
  
  it "returns nil if the signup is invalid" do
    Signup.new.to_developer.should be_nil
  end
  
  it "returns a developer" do
    Id.stub!(:new).and_return('a new id')
    BCrypt::Password.stub!(:create).with('spice123').and_return('must flow')
    
    signup = Signup.new({:name => 'paul', :email => 'paul@caladan.gov', :password => 'spice123', :confirm_password => 'spice123', :human => 'luigi'})
    developer = signup.to_developer
    developer.name.should == 'paul'
    developer.email.should == 'paul@caladan.gov'
    developer.password.should == 'must flow'
    developer.status.should == DeveloperStatus::Pending
    developer.action.should == 'a new id'
  end
end