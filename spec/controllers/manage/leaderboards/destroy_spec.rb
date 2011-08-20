require 'spec_helper'

describe Manage::LeaderboardsController, :destroy do
  extend ManageHelper
  
  setup
  it_ensures_a_logged_in_user :delete, :destroy
  it_ensures_developer_owns_the_game :delete, :destroy, Proc.new { 
    leaderboard = FactoryGirl.build(:leaderboard, {:game_id => ManageHelper.game_id})
    Leaderboard.stub!(:find_by_id).and_return(leaderboard)
    {:id => leaderboard.id} 
  }
  
  it "verifies that the leaderboard belongs to the game" do
    leaderboard = FactoryGirl.build(:leaderboard, {:game_id => Id.new})
    Leaderboard.stub!(:find_by_id).with(leaderboard.id).and_return(leaderboard)
    
    delete :destroy, {:id => leaderboard.id, :game_id => @game.id}
    response.should redirect_to('/manage/games')
    flash[:error].should == 'you do not have access to perform that action'
  end
  
  it "destroys the leaderboard" do
    leaderboard = FactoryGirl.build(:leaderboard, {:game_id => @game.id})
    Leaderboard.stub!(:find_by_id).with(leaderboard.id).and_return(leaderboard)
    leaderboard.should_receive(:destroy)
    delete :destroy, {:id => leaderboard.id, :game_id => @game.id}
  end
  
  it "redirect to index with message" do
    leaderboard = FactoryGirl.build(:leaderboard, {:game_id => @game.id})
    Leaderboard.stub!(:find_by_id).with(leaderboard.id).and_return(leaderboard)
    
    delete :destroy, {:id => leaderboard.id, :game_id => @game.id}
    
    flash[:info].should == "#{leaderboard.name} was successfully deleted"
    response.should redirect_to('/manage/leaderboards?id=' + @game.id.to_s)
  end
end