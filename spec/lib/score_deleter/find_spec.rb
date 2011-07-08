require 'spec_helper'

describe ScoreDeleter, :find do
  it "returns the all scores for a given scope" do
    leaderboard = Factory.build(:leaderboard)
    Factory.create(:score, {:username => 'b1', :leaderboard_id => leaderboard.id, :daily => Factory.build(:score_data, {:points => 23, :stamp => leaderboard.daily_stamp})})
    Factory.create(:score, {:username => 'b2', :leaderboard_id => leaderboard.id, :daily => Factory.build(:score_data, {:points => 33, :stamp => leaderboard.daily_stamp})})
    Factory.create(:score, {:username => 'b3', :leaderboard_id => leaderboard.id, :weekly => Factory.build(:score_data, {:points => 44, :stamp => leaderboard.weekly_stamp})})
      
    scores = ScoreDeleter.find(leaderboard, LeaderboardScope::Daily, nil)
    scores.count.should == 2
    scores[0][:username].should == 'b2'
    scores[1][:username].should == 'b1'
  end
  
  it "returns scores filtered by a username" do
    leaderboard = Factory.build(:leaderboard)
    Factory.create(:score, {:username => 'b3', :leaderboard_id => leaderboard.id, :weekly => Factory.build(:score_data, {:points => 1, :stamp => leaderboard.weekly_stamp})})
    Factory.create(:score, {:username => 'b4', :leaderboard_id => leaderboard.id, :weekly => Factory.build(:score_data, {:points => 2, :stamp => leaderboard.weekly_stamp})})
    Factory.create(:score, {:username => 'b4', :leaderboard_id => leaderboard.id, :weekly => Factory.build(:score_data, {:points => 3, :stamp => leaderboard.weekly_stamp})})
      
    scores = ScoreDeleter.find(leaderboard, LeaderboardScope::Weekly, 'b4')
    scores.count.should == 2
    scores[0][:points].should == 3
    scores[1][:points].should == 2
  end
  
  it "returns score data" do
    leaderboard = Factory.build(:leaderboard)
    Factory.create(:score, {:username => 'b3', :leaderboard_id => leaderboard.id, :overall => Factory.build(:score_data, {:points => 1, :data => 'over|9000'})})
      
    scores = ScoreDeleter.find(leaderboard, LeaderboardScope::Overall, nil)
    scores[0][:data].should == 'over|9000'
  end
end