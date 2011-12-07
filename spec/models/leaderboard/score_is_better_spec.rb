require 'spec_helper'

describe Leaderboard, :score_is_better? do
  
  it "returns true when the score is higher for a high to low leaderboard" do
    leaderboard = FactoryGirl.build(:leaderboard, {:type => LeaderboardType::HighToLow})
    LeaderboardScope::without_yesterday.each do |scope|
      leaderboard.score_is_better?(2, 1, scope).should be_true
    end
  end
  
  it "returns false when the score is lower for a high to low leaderboard" do
    leaderboard = FactoryGirl.build(:leaderboard, {:type => LeaderboardType::HighToLow})
    LeaderboardScope::without_yesterday.each do |scope|
      leaderboard.score_is_better?(1, 2, scope).should be_false
    end
  end
  
  it "returns false when the score is higher for a low to high leaderboard" do
    leaderboard = FactoryGirl.build(:leaderboard, {:type => LeaderboardType::LowToHigh})
    LeaderboardScope::without_yesterday.each do |scope|
      leaderboard.score_is_better?(2, 1, scope).should be_false
    end
  end
  
  it "returns true when the score is lower for a low to high leaderboard" do
    leaderboard = FactoryGirl.build(:leaderboard, {:type => LeaderboardType::LowToHigh})
    LeaderboardScope::without_yesterday.each do |scope|
      leaderboard.score_is_better?(1, 2, scope).should be_true
    end
  end
  
  it "returns true when the old score is a default" do
    leaderboard = FactoryGirl.build(:leaderboard, {:type => LeaderboardType::LowToHigh})
    LeaderboardScope::without_yesterday.each do |scope|
      leaderboard.score_is_better?(1, 0, scope).should be_true
    end
  end
  
  it "returns true for a lower daily score for special daily track latest mode" do
    leaderboard = FactoryGirl.build(:leaderboard, {:type => LeaderboardType::HighToLow, :mode => LeaderboardMode::DailyTracksLatest})
    leaderboard.score_is_better?(1, 200, LeaderboardScope::Daily).should be_true
    leaderboard.score_is_better?(1, 200, LeaderboardScope::Weekly).should be_false
    leaderboard.score_is_better?(1, 200, LeaderboardScope::Overall).should be_false
    
    leaderboard = FactoryGirl.build(:leaderboard, {:type => LeaderboardType::LowToHigh, :mode => LeaderboardMode::DailyTracksLatest})
    leaderboard.score_is_better?(300, 200, LeaderboardScope::Daily).should be_true
    leaderboard.score_is_better?(300, 200, LeaderboardScope::Weekly).should be_false
    leaderboard.score_is_better?(300, 200, LeaderboardScope::Overall).should be_false
  end
  
  it "returns true for a lower score for special all track latest mode" do
    leaderboard = FactoryGirl.build(:leaderboard, {:type => LeaderboardType::HighToLow, :mode => LeaderboardMode::AllTrackLatest})
    leaderboard.score_is_better?(1, 200, LeaderboardScope::Daily).should be_true
    leaderboard.score_is_better?(1, 200, LeaderboardScope::Weekly).should be_true
    leaderboard.score_is_better?(1, 200, LeaderboardScope::Overall).should be_true
    
    leaderboard = FactoryGirl.build(:leaderboard, {:type => LeaderboardType::LowToHigh, :mode => LeaderboardMode::AllTrackLatest})
    leaderboard.score_is_better?(300, 200, LeaderboardScope::Daily).should be_true
    leaderboard.score_is_better?(300, 200, LeaderboardScope::Weekly).should be_true
    leaderboard.score_is_better?(300, 200, LeaderboardScope::Overall).should be_true
  end
end