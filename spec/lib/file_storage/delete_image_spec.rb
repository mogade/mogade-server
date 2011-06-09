require 'spec_helper'

describe FileStorage, :delete_images do
  it "queues the image for deletion" do
    Time.stub!(:now).and_return(Time.utc(2008, 10, 26))
    FileStorage.delete_image('old_image')
    Store.redis.smembers('cleanup:images:081026').should == ['old_image']
  end
end