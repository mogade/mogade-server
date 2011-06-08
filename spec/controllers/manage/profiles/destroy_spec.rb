require 'spec_helper'

describe Manage::ProfilesController, :destroy do
  extend ManageHelper
  
  setup
  it_ensures_a_logged_in_user :delete, :destroy
  it_ensures_developer_owns_the_game :delete, :destroy

  it "removes the profile image" do
    profile = Profile.new
    Profile.should_receive(:load_for_game).with(@game).and_return(profile)
    profile.should_receive(:remove_image).with(5)
    delete :destroy, {:id => @game.id, :index => '5'}
  end
  
  it "returns the index" do
    profile = Profile.new
    Profile.stub!(:load_for_game).and_return(profile)
    profile.stub!(:delete_image)
    delete :destroy, {:id => @game.id, :index => '4'}
    
    json = ActiveSupport::JSON.decode(response.body)
    json['index'].should == 4
  end
  
end