require 'spec_helper'

describe Manage::LeaderboardsController, :scores do
  extend ManageHelper
  
  setup
  it_ensures_a_logged_in_user :get, :scores
  it_ensures_developer_owns_the_game :get, :scores
  
  it "loads the leaderboards and renders the view" do
    leaderboards = [Factory.build(:leaderboard)]
    
    Leaderboard.should_receive(:find_for_game).with(@game).and_return(leaderboards)
    get :scores, {:id => @game.id}
    
    assigns[:leaderboards].to_a.should == leaderboards
    response.should render_template('manage/leaderboards/scores')
  end
  
end