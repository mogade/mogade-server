require 'spec_helper'

describe Manage::LeaderboardsController, :update do
  extend ManageHelper
  
  setup
  it_ensures_a_logged_in_user :put, :update
  it_ensures_developer_owns_the_game :put, :update, Proc.new { 
    leaderboard = FactoryGirl.build(:leaderboard, {:game_id => ManageHelper.game_id})
    Leaderboard.stub!(:find_by_id).and_return(leaderboard)
    {:id => leaderboard.id} 
  }
  
  it "verifies that the leaderboard belongs to the game" do
    leaderboard = FactoryGirl.build(:leaderboard, {:game_id => Id.new})
    Leaderboard.stub!(:find_by_id).with(leaderboard.id).and_return(leaderboard)
    
    put :update, {:id => leaderboard.id, :game_id => @game.id}
    response.should redirect_to('/manage/games')
    flash[:error].should == 'you do not have access to perform that action'
  end
  
  it "updates the leaderboard" do
    leaderboard = FactoryGirl.build(:leaderboard, {:game_id => @game.id})
    Leaderboard.stub!(:find_by_id).with(leaderboard.id).and_return(leaderboard)
    leaderboard.should_receive(:update).with('n', 3, 2, 1)
    put :update, {:id => leaderboard.id, :game_id => @game.id, :name => 'n', :offset => '3', :type => '2', :mode => '1'}
  end
  
  it "redirect to index " do
    leaderboard = FactoryGirl.build(:leaderboard, {:game_id => @game.id})
    Leaderboard.stub!(:find_by_id).with(leaderboard.id).and_return(leaderboard)
    
    put :update, {:id => leaderboard.id, :game_id => @game.id}
    
    response.should redirect_to('/manage/leaderboards?id=' + @game.id.to_s)
  end
end