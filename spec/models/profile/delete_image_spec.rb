require 'spec_helper'

describe Profile, :delete_image do

  it "does nothing if the name is nil" do
    Profile.delete_image(nil)
    Store.redis.dbsize.should == 0
  end
  
  it "queues the image for deletion with a timestmap" do
    Time.stub!(:now).and_return(Time.utc(2008, 10, 26))
    Profile.delete_image('old_image')
    Store.redis.smembers('cleanup:images:081026').should == ['old_image']
  end
end