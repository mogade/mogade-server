require 'spec_helper'

describe Manage::LeaderboardsController, :index do
  extend ManageHelper
  
  setup
  it_ensures_a_logged_in_user :get, :index
  it_ensures_developer_owns_the_game :get, :index
  
  it "loads the leaderboards and renders the view" do
    leaderboards = [Factory.build(:leaderboard)]
    
    Leaderboard.should_receive(:find_for_game).with(@game).and_return(leaderboards)
    get :index, {:id => @game.id}
    
    assigns[:leaderboards].to_a.should == leaderboards
    response.should render_template('manage/leaderboards/index')
  end
  
end