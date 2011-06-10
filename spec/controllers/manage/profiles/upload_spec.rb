require 'spec_helper'

describe Manage::ProfilesController, :upload do
  extend ManageHelper
  
  setup
  it_ensures_a_logged_in_user :post, :upload
  it_ensures_developer_owns_the_game :post, :upload

  it "updates the profile image" do
    profile = Profile.new
    Profile.should_receive(:load_for_game).with(@game).and_return(profile)
    profile.should_receive(:save_image).with('file.nme', anything(), 3).and_return('')
    post :upload, {:id => @game.id, :index => '3', :qqfile => 'file.nme'}
  end
  
  it "returns the index and filename for banner" do
    profile = Profile.new
    Profile.stub!(:load_for_game).and_return(profile)
    profile.stub!(:save_image).and_return('xtfn')
    post :upload, {:id => @game.id, :index => '0', :qqfile => 'file.nme'}
    
    json = ActiveSupport::JSON.decode(response.body)
    json['index'].should == 0
    json['name'].should == 'xtfn'
  end
  
  it "returns the index and thumbnail filename for non-banner" do
    profile = Profile.new
    Profile.stub!(:load_for_game).and_return(profile)
    profile.stub!(:save_image).and_return('xtfn')
    post :upload, {:id => @game.id, :index => '2', :qqfile => 'file.nme'}
    
    json = ActiveSupport::JSON.decode(response.body)
    json['index'].should == 2
    json['name'].should == 'thumbxtfn'
  end
  
end