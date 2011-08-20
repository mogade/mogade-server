require 'spec_helper'
require 'bcrypt'

describe Developer, :reset_password do
  
  it "should set the encrypted password" do
    BCrypt::Password.stub!(:create).and_return('oh noes')
    developer = FactoryGirl.build(:developer)
    developer.reset_password('over 9000!')
    developer.password.should == 'oh noes'
  end
  
  it "should enable thep developer" do
    developer = FactoryGirl.build(:developer, {:status => DeveloperStatus::Pending})
    developer.reset_password('over 9000!')
    developer.status.should == DeveloperStatus::Enabled
  end
  
  it "should save the developer" do
    BCrypt::Password.stub!(:create).and_return('burp')
    developer = FactoryGirl.build(:developer, {:status => DeveloperStatus::Pending})
    developer.reset_password('super bored')

    Developer.count({:_id => developer.id, :password => 'burp', :status => DeveloperStatus::Enabled}).should == 1
  end
  
end