require 'spec_helper'

describe HighScores, :load do
  it "return's the player's high scores for the given leaderboard" do
    leaderboard = Factory.build(:leaderboard)
    player = Factory.build(:player)
    Factory.create(:high_scores, {:leaderboard_id => leaderboard.id, :unique => player.unique, :daily => Factory.build(:high_score, {:points => 122, :stamp => Time.now}), :weekly => Factory.build(:high_score, {:points => 234, :stamp => Time.now}), :overall => Factory.build(:high_score, {:points => 400})})
    
    scores = HighScores.load(leaderboard, player)
    scores.leaderboard_id.should == leaderboard.id
    scores.unique.should == player.unique
    scores.daily.points.should == 122
  end
  it "return's an empty new scores object if the player doesn't have any scores for the leaderboard" do
    leaderboard = Factory.build(:leaderboard)
    player = Factory.build(:player)
    
    scores = HighScores.load(leaderboard, player)
    scores.leaderboard_id.should == leaderboard.id
    scores.unique.should == player.unique
    scores.userkey.should == player.userkey
    scores.daily.points.should == 0
    scores.weekly.points.should == 0
  end
  it "returns 0 for the daily score if it is no longer the correct day" do
    leaderboard = Factory.build(:leaderboard)
    player = Factory.build(:player)
    Factory.create(:high_scores, {:leaderboard_id => leaderboard.id, :unique => player.unique, :daily => Factory.build(:high_score, {:points => 122, :stamp => Time.now - 1000000})})
    
    scores = HighScores.load(leaderboard, player)
    scores.leaderboard_id.should == leaderboard.id
    scores.unique.should == player.unique
    scores.daily.points.should == 0
  end
  it "returns 0 for the weekly score if it is no longer the correct week" do
    leaderboard = Factory.build(:leaderboard)
    player = Factory.build(:player)
    Factory.create(:high_scores, {:leaderboard_id => leaderboard.id, :unique => player.unique, :weekly => Factory.build(:high_score, {:points => 422, :stamp => Time.now - 1000000})})
    
    scores = HighScores.load(leaderboard, player)
    scores.leaderboard_id.should == leaderboard.id
    scores.unique.should == player.unique
    scores.weekly.points.should == 0
  end
  
end