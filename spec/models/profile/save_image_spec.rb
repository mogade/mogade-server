require 'spec_helper'

describe Profile, :save_image do

  it "returns nil if the data is larger then the maximum allowed size" do
    profile = Factory.build(:profile)
    profile.save_image('test.jpg', 'a' * (Settings.max_image_length + 1), 0).should be_nil
  end
  
  it "returns nil if the file doesn't have a valid extension" do
    profile = Factory.build(:profile)
    ['something.bmp', 'blah', '.ds_store'].each do |file|
      profile.save_image(file, 'data', 0).should be_nil
    end
  end
  
  it "saves the image to the store" do
    id = Id.new
    index = 0
    Id.stub!(:new).and_return(id)
    profile = Factory.build(:profile)
    ['first.png', 'second.jpg', 'third.jpeg', 'forth.gif'].each do |file|
      Store.should_receive(:save_image).with(id.to_s + '_' +  file, 'data', nil)
      profile.save_image(file, 'data', index)
      index += 1
    end
  end
  
  it "passes the previous image to the store" do
    id = Id.new
    index = 0
    Id.stub!(:new).and_return(id)
    profile = Factory.build(:profile, {:images => ['old_first.png', 'old_second.jpg', 'old_third.jpeg', 'old_forth.gif']})
    ['first.png', 'second.jpg', 'third.jpeg', 'forth.gif'].each do |file|
      Store.should_receive(:save_image).with(id.to_s + '_' +  file, 'data', 'old_' + file)
      profile.save_image(file, 'data', index)
      index += 1
    end
  end
  
  it "saves the image info" do
    id = Id.new
    index = 0
    Id.stub!(:new).and_return(id)
    profile = Factory.build(:profile)
    filenames = ['first.png', 'second.jpg', 'third.jpeg', 'forth.gif']
    filenames.each do |file|
      Store.stub!(:save_image)
      profile.save_image(file, 'data', index)
      Profile.find_by_id(profile.id).images.should == filenames[0..index].map{|name| id.to_s + '_' + name}
      index += 1
    end
  end
end