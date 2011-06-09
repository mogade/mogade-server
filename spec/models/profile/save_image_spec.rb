require 'spec_helper'

describe Profile, :save_image do

  it "returns nil if the data is larger then the maximum allowed size" do
    profile = Factory.build(:profile)
    profile.save_image('test.jpg', 'a' * (Settings.max_image_length + 1), 0).should be_nil
  end
  
  it "returns nil if the index is greater than 6" do
    profile = Factory.build(:profile)
    profile.save_image('test.jpg', 'a', 7).should be_nil
  end
  
  it "returns nil if the filename is blank" do
    profile = Factory.build(:profile)
    profile.save_image('', 'a', 6).should be_nil
  end
  
  it "returns nil if the file doesn't have a valid extension" do
    profile = Factory.build(:profile)
    ['something.bmp', 'blah', '.ds_store'].each do |file|
      profile.save_image(file, 'data', 0).should be_nil
    end
  end
  
  it "saves the image to the store" do
    profile = Factory.build(:profile)
    FileStorage.should_receive(:save_image).with('image.png', 'data', nil)
    profile.save_image('image.png', 'data', 0)  
  end
  
  it "passes the previous image to the store" do
    profile = Factory.build(:profile, {:images => ['old_image0', 'old_image1', 'old_image2']})
    FileStorage.should_receive(:save_image).with('another.gif', 'data2', 'old_image1')
    profile.save_image('another.gif', 'data2', 1)
  end
  
  it "saves the image info" do
    profile = Factory.build(:profile)
    FileStorage.stub(:save_image).and_return('the_new_name')
    profile.save_image('another.jpg', 'data2', 0)
    Profile.find_by_id(profile.id).images.should == ['the_new_name']
  end
end