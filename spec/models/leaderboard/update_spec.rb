require 'spec_helper'

describe Leaderboard, :update do
  it "updates the leaderboard" do
    leaderboard = Factory.build(:leaderboard, {:name => 'old name', :offset => 1, :type => LeaderboardType::LowToHigh})
    leaderboard.update('new name', -4, LeaderboardType::HighToLow)
    leaderboard.name.should == 'new name'
    leaderboard.offset.should == -4
    leaderboard.type.should == LeaderboardType::HighToLow
    Leaderboard.count({:_id => leaderboard.id, :name => 'new name', :offset => -4, :type => LeaderboardType::HighToLow}).should == 1
  end
end