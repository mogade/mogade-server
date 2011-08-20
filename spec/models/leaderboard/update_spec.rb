require 'spec_helper'

describe Leaderboard, :update do
  it "updates the leaderboard" do
    leaderboard = FactoryGirl.create(:leaderboard, {:name => 'old name', :offset => 1, :type => LeaderboardType::LowToHigh, :mode => LeaderboardMode::Normal})
    leaderboard.update('new name', -4, LeaderboardType::HighToLow, LeaderboardMode::DailyTracksLatest)
    leaderboard.name.should == 'new name'
    leaderboard.offset.should == -4
    leaderboard.type.should == LeaderboardType::HighToLow
    leaderboard.mode.should == LeaderboardMode::DailyTracksLatest
    Leaderboard.count.should == 1
    Leaderboard.count({
      :_id => leaderboard.id, 
      :name => 'new name', 
      :offset => -4, 
      :type => LeaderboardType::HighToLow,
      :mode => LeaderboardMode::DailyTracksLatest}).should == 1
  end
end