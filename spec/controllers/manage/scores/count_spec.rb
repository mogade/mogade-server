require 'spec_helper'

describe Manage::ScoresController, :count do
  extend ManageHelper
  
  setup
  it_ensures_a_logged_in_user :get, :count
  it_ensures_developer_owns_the_game :get, :count, Proc.new { 
    leaderboard = Factory.build(:leaderboard, {:game_id => ManageHelper.game_id})
    Leaderboard.stub!(:find_by_id).and_return(leaderboard)
    {:id => leaderboard.id, :scope => 1, :field => 1} 
  }

  it "verifies that the leaderboard belongs to the game" do
    leaderboard = Factory.build(:leaderboard, {:game_id => Id.new})
    Leaderboard.stub!(:find_by_id).with(leaderboard.id).and_return(leaderboard)
    
    get :count, {:id => leaderboard.id, :game_id => @game.id}
    response.should redirect_to('/manage/games')
    flash[:error].should == 'you do not have access to perform that action'
  end

  it "gets and returns the count from the ScoreDeleter" do
    leaderboard = Factory.build(:leaderboard, {:game_id => @game.id})
    Leaderboard.stub!(:find_by_id).with(leaderboard.id).and_return(leaderboard)
    
    ScoreDeleter.should_receive(:count).with(leaderboard, LeaderboardScope::Daily, ScoreDeleterField::UserName, 4, 'baron').and_return(454)
    get :count, {:id => leaderboard.id, :game_id => @game.id, :scope => LeaderboardScope::Daily, :field => '1', :operator => '4', :value => 'baron'}
    
    json = ActiveSupport::JSON.decode(response.body)
    json['count'].should == 454   
  end

end