require 'spec_helper'

describe Manage::ScoresController, :find do
  extend ManageHelper
  
  setup
  it_ensures_a_logged_in_user :get, :find
  it_ensures_developer_owns_the_game :get, :find, Proc.new { 
    leaderboard = FactoryGirl.build(:leaderboard, {:game_id => ManageHelper.game_id})
    Leaderboard.stub!(:find_by_id).and_return(leaderboard)
    {:id => leaderboard.id, :scope => 1} 
  }

  it "verifies that the leaderboard belongs to the game" do
    leaderboard = FactoryGirl.build(:leaderboard, {:game_id => Id.new})
    Leaderboard.stub!(:find_by_id).with(leaderboard.id).and_return(leaderboard)
    
    get :find, {:id => leaderboard.id, :game_id => @game.id}
    response.should redirect_to('/manage/games')
    flash[:error].should == 'you do not have access to perform that action'
  end

  it "gets and returns the scores from the ScoreDeleter" do
    leaderboard = FactoryGirl.build(:leaderboard, {:game_id => @game.id})
    Leaderboard.stub!(:find_by_id).with(leaderboard.id).and_return(leaderboard)
    
    ScoreDeleter.should_receive(:find).with(leaderboard, LeaderboardScope::Daily, 'my name').and_return(["it doesn't matter"])
    get :find, {:id => leaderboard.id, :game_id => @game.id, :scope => '1', :username => 'my name' }
    
    json = ActiveSupport::JSON.decode(response.body)
    json.should == ["it doesn't matter"]
  end

end