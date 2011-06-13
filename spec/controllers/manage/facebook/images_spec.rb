require 'spec_helper'

describe Manage::FacebookController, :images do
  extend ManageHelper
  
  setup
  it_ensures_a_logged_in_user :get, :images
  it_ensures_developer_owns_the_game :get, :images
  
  it "load the profile" do
    profile = Profile.new
    Profile.should_receive(:load_for_game).with(@game).and_return(profile)
    get :images, {:id => @game.id}
    
    response.should render_template('manage/facebook/images')
    assigns[:profile].should == profile
  end
  
end