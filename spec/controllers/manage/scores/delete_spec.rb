require 'spec_helper'

describe Manage::ScoresController, :destroy do
  extend ManageHelper
  
  setup
  it_ensures_a_logged_in_user :delete, :destroy
  it_ensures_developer_owns_the_game :delete, :destroy, Proc.new { 
    leaderboard = Factory.build(:leaderboard, {:game_id => ManageHelper.game_id})
    Leaderboard.stub!(:find_by_id).and_return(leaderboard)
    {:id => leaderboard.id, :scope => 1, :field => 1} 
  }

  it "verifies that the leaderboard belongs to the game" do
    leaderboard = Factory.build(:leaderboard, {:game_id => Id.new})
    Leaderboard.stub!(:find_by_id).with(leaderboard.id).and_return(leaderboard)
    
    delete :destroy, {:id => leaderboard.id, :game_id => @game.id}
    response.should redirect_to('/manage/games')
    flash[:error].should == 'you do not have access to perform that action'
  end

  it "deletes the scores" do
    leaderboard = Factory.build(:leaderboard, {:game_id => @game.id})
    Leaderboard.stub!(:find_by_id).with(leaderboard.id).and_return(leaderboard)
    
    ScoreDeleter.should_receive(:delete).with(leaderboard, LeaderboardScope::Weekly, ScoreDeleterField::Points, 2, '5').and_return(454)
    delete :destroy, {:id => leaderboard.id, :game_id => @game.id, :scope => LeaderboardScope::Weekly, :field => ScoreDeleterField::Points, :operator => '2', :value => '5'}
    
    response.should redirect_to('/manage/scores?id=' + @game.id.to_s)
  end

end