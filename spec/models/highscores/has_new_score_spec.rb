require 'spec_helper'

describe HighScores, :has_new_score do
  it "updates the daily information with a new better score" do
    leaderboard = Factory.build(:leaderboard)
    scores = HighScores.load(leaderboard, Factory.build(:player))
    scores.has_new_score(250)
    scores.daily_points.should == 250
    scores.daily_dated.should == leaderboard.daily_start
  end

  it "does not updates the daily information with a worse score" do
    leaderboard = Factory.build(:leaderboard)
    Factory.create(:high_scores, {:daily_points => 500, :daily_dated => leaderboard.daily_start})
    scores = HighScores.load(leaderboard, Factory.build(:player))
    scores.has_new_score(112)
    scores.daily_points.should == 500
  end
  
  it "updates the weekly information with a new better score" do
    leaderboard = Factory.build(:leaderboard)
    scores = HighScores.load(leaderboard, Factory.build(:player))
    scores.has_new_score(77)
    scores.weekly_points.should == 77
    scores.weekly_dated.should == leaderboard.weekly_start
  end

  it "does not updates the weekly information with a worse score" do
    leaderboard = Factory.build(:leaderboard)
    Factory.create(:high_scores, {:weekly_points => 505, :weekly_dated => leaderboard.weekly_start})
    scores = HighScores.load(leaderboard, Factory.build(:player))
    scores.has_new_score(111)
    scores.weekly_points.should == 505
  end
  
  it "updates the overall information with a new better score" do
    leaderboard = Factory.build(:leaderboard)
    scores = HighScores.load(leaderboard, Factory.build(:player))
    scores.has_new_score(72)
    scores.overall_points.should == 72
  end
  
end