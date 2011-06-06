require 'spec_helper'

describe Manage::ProfilesController, :create do
  extend ManageHelper
  
  setup
  it_ensures_a_logged_in_user :post, :create
  it_ensures_developer_owns_the_game :post, :create
  
  it "does not save an invalid profile" do
    profile = Profile.new
    
    Profile.stub!(:create_or_update).and_return(profile)
    profile.should_receive(:valid?).and_return(false)
    post :create, {:game_id => @game.id}
  
    Profile.count.should == 0  
  end
  
  it "saves a valid profile" do
    post :create, {:game_id => @game.id, :name => 'gn', :enabled => '1', :description => 'desc'}
    Profile.count({:_id => @game.id, :name => 'gn', :enabled => true, :description => 'desc'}).should == 1
  end
  
end