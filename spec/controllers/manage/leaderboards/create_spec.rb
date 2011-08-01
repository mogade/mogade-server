require 'spec_helper'

describe Manage::LeaderboardsController, :create do
  extend ManageHelper
  
  setup
  it_ensures_a_logged_in_user :post, :create
  it_ensures_developer_owns_the_game :post, :create
  
  it "does not save an invalid leaderboard" do
    leaderboard = Leaderboard.new
    
    Leaderboard.stub!(:create).and_return(leaderboard)
    leaderboard.should_receive(:valid?).and_return(false)
    post :create, {:game_id => @game.id}
  
    Leaderboard.count.should == 0  
  end
  
  it "saves a valid leaderboard" do
    post :create, {:game_id => @game.id, :name => 'tlb', :offset => '4', :type => '1', :mode => '2'}
    Leaderboard.count({
      :game_id => @game.id, 
      :name => 'tlb', 
      :offset => 4, 
      :type => LeaderboardType::HighToLow,
      :mode => LeaderboardMode::DailyTracksLatest}).should == 1
  end
  
  it "redirects to index page" do
    post :create, {:game_id => @game.id}
    response.should redirect_to('http://test.host/manage/leaderboards?id=' + @game.id.to_s)
  end
end