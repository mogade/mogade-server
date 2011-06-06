require 'spec_helper'

describe Manage::ProfilesController, :index do
  extend ManageHelper
  
  setup
  it_ensures_a_logged_in_user :get, :index
  it_ensures_developer_owns_the_game :get, :index
  
  it "load the profile" do
    profile = Profile.new
    Profile.should_receive(:load_for_game).with(@game).and_return(profile)
    get :index, {:id => @game.id}
    
    response.should render_template('manage/profiles/index')
    assigns[:profile].should == profile
  end
  
end