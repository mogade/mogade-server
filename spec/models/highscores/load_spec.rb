require 'spec_helper'

describe HighScores, :load do
  it "return's the player's high scores for the given leaderboard" do
    leaderboard = Factory.build(:leaderboard)
    player = Factory.build(:player)
    Factory.create(:high_scores, {:daily_points => 122, :daily_dated => Time.now, :weekly_points => 234, :weekly_dated => Time.now, :leaderboard_id => leaderboard.id, :unique => player.unique})
    
    scores = HighScores.load(leaderboard, player)
    scores.leaderboard_id.should == leaderboard.id
    scores.unique.should == player.unique
    scores.daily_points.should == 122
  end
  it "return's an empty new scores object if the player doesn't have any scores for the leaderboard" do
    leaderboard = Factory.build(:leaderboard)
    player = Factory.build(:player)
    
    scores = HighScores.load(leaderboard, player)
    scores.leaderboard_id.should == leaderboard.id
    scores.unique.should == player.unique
    scores.daily_points.should == 0
    scores.weekly_points.should == 0
  end
  it "returns 0 for the daily score if it is no longer the correct day" do
    leaderboard = Factory.build(:leaderboard)
    player = Factory.build(:player)
    Factory.create(:high_scores, {:daily_points => 122, :daily_dated => Time.now - 1000000, :leaderboard_id => leaderboard.id, :unique => player.unique})
    
    scores = HighScores.load(leaderboard, player)
    scores.leaderboard_id.should == leaderboard.id
    scores.unique.should == player.unique
    scores.daily_points.should == 0
  end
  it "returns 0 for the weekly score if it is no longer the correct week" do
    leaderboard = Factory.build(:leaderboard)
    player = Factory.build(:player)
    Factory.create(:high_scores, {:weekly_points => 442, :weekly_dated => Time.now - 1000000, :leaderboard_id => leaderboard.id, :unique => player.unique})
    
    scores = HighScores.load(leaderboard, player)
    scores.leaderboard_id.should == leaderboard.id
    scores.unique.should == player.unique
    scores.weekly_points.should == 0
  end
  
end