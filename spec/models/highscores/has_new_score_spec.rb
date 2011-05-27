require 'spec_helper'

describe HighScores, :has_new_score do
  it "updates the daily information with a new better score" do
    leaderboard = Factory.build(:leaderboard)
    scores = HighScores.load(leaderboard, Factory.build(:player))
    scores.has_new_score(250)
    scores.daily.points.should == 250
    scores.daily.stamp.should == leaderboard.daily_stamp
  end

  it "does not updates the daily information with a worse score" do
    leaderboard = Factory.build(:leaderboard)
    Factory.create(:high_scores, {:unique => Factory.build(:player).unique, :daily => Factory.build(:high_score, {:points => 500, :stamp => leaderboard.daily_stamp})})
    scores = HighScores.load(leaderboard, Factory.build(:player))
    scores.has_new_score(112)
    scores.daily.points.should == 500
  end
  
  it "updates the weekly information with a new better score" do
    leaderboard = Factory.build(:leaderboard)
    scores = HighScores.load(leaderboard, Factory.build(:player))
    scores.has_new_score(77)
    scores.weekly.points.should == 77
    scores.weekly.stamp.should == leaderboard.weekly_stamp
  end

  it "does not updates the weekly information with a worse score" do
    leaderboard = Factory.build(:leaderboard)
    Factory.create(:high_scores, {:unique => Factory.build(:player).unique, :weekly => Factory.build(:high_score, {:points => 505, :stamp => leaderboard.weekly_stamp})})
    scores = HighScores.load(leaderboard, Factory.build(:player))
    scores.has_new_score(111)
    scores.weekly.points.should == 505
  end
  
  it "updates the overall information with a new better score" do
    leaderboard = Factory.build(:leaderboard)
    scores = HighScores.load(leaderboard, Factory.build(:player))
    scores.has_new_score(72)
    scores.overall.points.should == 72
  end
  
  it "saves the high score when this is new (and thus something has changed)" do
    leaderboard = Factory.build(:leaderboard)
    player = Factory.build(:player)
    scores = HighScores.load(leaderboard, player)
    scores.has_new_score(122)
    HighScores.count({:leaderboard_id => leaderboard.id, :unique => player.unique, 
      'd.p' => 122, 'd.s' => leaderboard.daily_stamp,
      'w.p' => 122, 'w.s' => leaderboard.weekly_stamp, 
      'o.p' => 122}).should == 1
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
    Factory.create(:high_scores, {:daily => Factory.build(:high_score, {:points => 200, :stamp => leaderboard.daily_stamp}), :weekly => Factory.build(:high_score, {:points => 505, :stamp => leaderboard.weekly_stamp}), :overall => Factory.build(:high_score, {:points => 999}), :unique => Factory.build(:player).unique})
    player = Factory.build(:player)
    scores = HighScores.load(leaderboard, player)
    Rank.should_not_receive(:save).with(any_args())
    scores.has_new_score(122)
  end
  
  
  it "saves the high score when with partial new scores" do
    leaderboard = Factory.build(:leaderboard)
    Factory.create(:high_scores, {:daily => Factory.build(:high_score, {:points => 300, :stamp => leaderboard.daily_stamp - 1000000}), :weekly => Factory.build(:high_score, {:points => 300, :stamp => leaderboard.weekly_stamp}), :overall => Factory.build(:high_score, {:points => 400}), :unique => Factory.build(:player).unique})
    player = Factory.build(:player)
    scores = HighScores.load(leaderboard, player)
    scores.has_new_score(250)
    HighScores.count({:leaderboard_id => leaderboard.id, :unique => player.unique, 
      'd.p'  => 250, 'd.s' => leaderboard.daily_stamp,
      'w.p'  => 300, 'w.s' => leaderboard.weekly_stamp, 
      'o.p' => 400}).should == 1
  end
  
  it "returns high score changed information" do
    leaderboard = Factory.build(:leaderboard)
    Factory.create(:high_scores, {:daily => Factory.build(:high_score, {:points => 300, :stamp => leaderboard.daily_stamp - 1000000}), :weekly => Factory.build(:high_score, {:points => 300, :stamp => leaderboard.weekly_stamp}), :overall => Factory.build(:high_score, {:points => 400}), :unique => Factory.build(:player).unique})
    player = Factory.build(:player)
    scores = HighScores.load(leaderboard, player)
    changed = scores.has_new_score(250)
    changed[LeaderboardScope::Daily].should be_true
    changed[LeaderboardScope::Weekly].should be_false
    changed[LeaderboardScope::Overall].should be_false
  end
  
  it "does not treat equal scores as better" do
    leaderboard = Factory.build(:leaderboard)
    Factory.create(:high_scores, {:daily => Factory.build(:high_score, {:points => 300, :stamp => leaderboard.daily_stamp}), :weekly => Factory.build(:high_score, {:points => 300, :stamp => leaderboard.weekly_stamp}), :overall => Factory.build(:high_score, {:points => 300}), :unique => Factory.build(:player).unique})
    player = Factory.build(:player)
    scores = HighScores.load(leaderboard, player)
    changed = scores.has_new_score(300)
    changed[LeaderboardScope::Daily].should be_false
    changed[LeaderboardScope::Weekly].should be_false
    changed[LeaderboardScope::Overall].should be_false
  end
end