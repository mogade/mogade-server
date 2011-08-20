require 'spec_helper'

describe Profile, :delete_image do
  
  it "deletes the image from the store" do
    profile = FactoryGirl.build(:profile, {:images => ['the_file_name.gif', 'another_file.jpg']})
    FileStorage.should_receive(:delete_image).with('the_file_name.gif')
    profile.delete_image(0)
  end
  
  it "removes the image name from the profile" do
    profile = FactoryGirl.create(:profile, {:images => ['the_file_name.gif', 'another_file.jpg']})
    FileStorage.stub!(:delete_image)
    profile.delete_image(1)
    Profile.find_by_id(profile.id).images.should == ['the_file_name.gif', nil]
  end
end
