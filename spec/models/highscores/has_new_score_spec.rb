require 'spec_helper'

describe HighScores, :has_new_score do
  it "updates the daily information with a new better score" do
    leaderboard = Factory.build(:leaderboard)
    scores = HighScores.load(leaderboard, Factory.build(:player))
    scores.has_new_score(250)
    scores.daily_points.should == 250
    scores.daily_stamp.should == leaderboard.daily_stamp
  end

  it "does not updates the daily information with a worse score" do
    leaderboard = Factory.build(:leaderboard)
    Factory.create(:high_scores, {:daily_points => 500, :daily_stamp => leaderboard.daily_stamp, :unique => Factory.build(:player).unique})
    scores = HighScores.load(leaderboard, Factory.build(:player))
    scores.has_new_score(112)
    scores.daily_points.should == 500
  end
  
  it "updates the weekly information with a new better score" do
    leaderboard = Factory.build(:leaderboard)
    scores = HighScores.load(leaderboard, Factory.build(:player))
    scores.has_new_score(77)
    scores.weekly_points.should == 77
    scores.weekly_stamp.should == leaderboard.weekly_stamp
  end

  it "does not updates the weekly information with a worse score" do
    leaderboard = Factory.build(:leaderboard)
    Factory.create(:high_scores, {:weekly_points => 505, :weekly_stamp => leaderboard.weekly_stamp, :unique => Factory.build(:player).unique})
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
      :daily_points => 122, :daily_stamp => leaderboard.daily_stamp,
      :weekly_points => 122, :weekly_stamp => leaderboard.weekly_stamp, 
      :overall_points => 122}).should == 1
  end
  
  it "saves a new rank for a new high score for each scope" do
    leaderboard = Factory.build(:leaderboard)
    player = Factory.build(:player)
    scores = HighScores.load(leaderboard, player)
    Rank.should_receive(:save).with(leaderboard, LeaderboardScope::Daily, player.unique, 122)
    Rank.should_receive(:save).with(leaderboard, LeaderboardScope::Weekly, player.unique, 122)
    Rank.should_receive(:save).with(leaderboard, LeaderboardScope::Overall, player.unique, 122)
    scores.has_new_score(122)
  end
  
  it "does not save new ranks if they are worse" do
    leaderboard = Factory.build(:leaderboard)
    Factory.create(:high_scores, {:daily_points => 200, :daily_stamp => leaderboard.daily_stamp, :weekly_points => 505, :weekly_stamp => leaderboard.weekly_stamp, :overall_points => 999, :unique => Factory.build(:player).unique})
    player = Factory.build(:player)
    scores = HighScores.load(leaderboard, player)
    Rank.should_not_receive(:save).with(any_args())
    scores.has_new_score(122)
  end
  
  
  it "saves the high score when with partial new scores" do
    leaderboard = Factory.build(:leaderboard)
    Factory.create(:high_scores, {:daily_points => 300, :daily_stamp => leaderboard.daily_stamp - 1000000, :weekly_points => 300, :weekly_stamp => leaderboard.weekly_stamp, :overall_points => 400, :unique => Factory.build(:player).unique})
    player = Factory.build(:player)
    scores = HighScores.load(leaderboard, player)
    scores.has_new_score(250)
    HighScores.count({:leaderboard_id => leaderboard.id, :unique => player.unique, 
      :daily_points => 250, :daily_stamp => leaderboard.daily_stamp,
      :weekly_points => 300, :weekly_stamp => leaderboard.weekly_stamp, 
      :overall_points => 400}).should == 1
  end
  
  it "returns high score changed information" do
    leaderboard = Factory.build(:leaderboard)
    Factory.create(:high_scores, {:daily_points => 300, :daily_stamp => leaderboard.daily_stamp - 1000000, :weekly_points => 300, :weekly_stamp => leaderboard.weekly_stamp, :overall_points => 400, :unique => Factory.build(:player).unique})
    player = Factory.build(:player)
    scores = HighScores.load(leaderboard, player)
    changed = scores.has_new_score(250)
    changed[LeaderboardScope::Daily].should be_true
    changed[LeaderboardScope::Weekly].should be_false
    changed[LeaderboardScope::Overall].should be_false
  end
  
  it "does not treat equal scores as better" do
    leaderboard = Factory.build(:leaderboard)
    Factory.create(:high_scores, {:daily_points => 300, :daily_stamp => leaderboard.daily_stamp, :weekly_points => 300, :weekly_stamp => leaderboard.weekly_stamp, :overall_points => 300, :unique => Factory.build(:player).unique})
    player = Factory.build(:player)
    scores = HighScores.load(leaderboard, player)
    changed = scores.has_new_score(300)
    changed[LeaderboardScope::Daily].should be_false
    changed[LeaderboardScope::Weekly].should be_false
    changed[LeaderboardScope::Overall].should be_false
  end
end