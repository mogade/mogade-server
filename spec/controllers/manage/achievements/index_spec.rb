require 'spec_helper'

describe Manage::AchievementsController, :index do
  extend ManageHelper
  
  setup
  it_ensures_a_logged_in_user :get, :index
  it_ensures_developer_owns_the_game :get, :index
  
  it "loads the achievements and renders the view" do
    achievements = [Factory.build(:achievement)]
    
    Achievement.should_receive(:find_for_game).with(@game).and_return(achievements)
    get :index, {:id => @game.id}
    
    assigns[:achievements].to_a.should == achievements
    response.should render_template('manage/achievements/index')
  end
  
end