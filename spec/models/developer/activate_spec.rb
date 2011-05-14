require 'spec_helper'
require 'bcrypt'

describe Developer, :activate do
  
  it "enables the developer" do
    developer = Factory.create(:developer, {:status => DeveloperStatus::Pending})
    developer.activate!
    developer.status.should == DeveloperStatus::Enabled
    Developer.count({:_id => developer.id, :status => DeveloperStatus::Enabled}).should == 1
  end

end