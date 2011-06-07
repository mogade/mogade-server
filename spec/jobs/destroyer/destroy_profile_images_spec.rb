require 'spec_helper'
require './deploy/jobs/destroyer'

describe Destroyer, 'destroy profile images' do
  it "skips images deleted today" do
    key = "cleanup:images:#{Time.now.strftime("%y%m%d")}"
    Store.redis.sadd(key, "an image")
    Destroyer.new.destroy_profile_images('bucket')
    Store.redis.scard(key).should == 1
  end
  
  it "deletes all images for past days" do
    now = Time.now
    key1 = "cleanup:images:#{(now - 86400).strftime("%y%m%d")}"
    key2 = "cleanup:images:#{(now - (2 * 86400)).strftime("%y%m%d")}"
    Store.redis.sadd(key1, "image1")
    Store.redis.sadd(key1, "image2")
    Store.redis.sadd(key2, "image3")
    
    AWS::S3::S3Object.should_receive(:delete).with('image3', 'tb').ordered
    AWS::S3::S3Object.should_receive(:delete).with('image1', 'tb').ordered
    AWS::S3::S3Object.should_receive(:delete).with('image2', 'tb').ordered
    Destroyer.new.destroy_profile_images('tb')
    Store.redis.keys.length.should == 0
  end
end