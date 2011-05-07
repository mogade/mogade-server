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
  
  it "saves the high score when this is new (and thus something has changed)" do
    leaderboard = Factory.build(:leaderboard)
    player = Factory.build(:player)
    scores = HighScores.load(leaderboard, player)
    scores.has_new_score(122)
    HighScores.count({:leaderboard_id => leaderboard.id, :unique => player.unique, 
      :daily_points => 122, :daily_dated => leaderboard.daily_start,
      :weekly_points => 122, :weekly_dated => leaderboard.weekly_start, 
      :overall_points => 122}).should == 1
  end
  
  it "saves the high score when with partial new scores" do
    leaderboard = Factory.build(:leaderboard)
    Factory.create(:high_scores, {:daily_points => 300, :daily_dated => leaderboard.daily_start - 1000000, :weekly_points => 300, :weekly_dated => leaderboard.weekly_start, :overall_points => 400})
    player = Factory.build(:player)
    scores = HighScores.load(leaderboard, player)
    scores.has_new_score(250)
    HighScores.count({:leaderboard_id => leaderboard.id, :unique => player.unique, 
      :daily_points => 250, :daily_dated => leaderboard.daily_start,
      :weekly_points => 300, :weekly_dated => leaderboard.weekly_start, 
      :overall_points => 400}).should == 1
  end
  
  it "returns high score changed information" do
    leaderboard = Factory.build(:leaderboard)
    Factory.create(:high_scores, {:daily_points => 300, :daily_dated => leaderboard.daily_start - 1000000, :weekly_points => 300, :weekly_dated => leaderboard.weekly_start, :overall_points => 400})
    player = Factory.build(:player)
    scores = HighScores.load(leaderboard, player)
    changed = scores.has_new_score(250)
    changed[:daily].should be_true
    changed[:weekly].should be_false
    changed[:overall].should be_false
  end
end