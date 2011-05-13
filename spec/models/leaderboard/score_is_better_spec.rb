require 'spec_helper'

describe Leaderboard, :score_is_better? do
  
  it "returns true when the score is higher for a high to low leaderboard" do
    Factory.build(:leaderboard, {:type => LeaderboardType::HighToLow}).score_is_better?(2, 1).should be_true
  end
  
  it "returns false when the score is lower for a high to low leaderboard" do
    Factory.build(:leaderboard, {:type => LeaderboardType::HighToLow}).score_is_better?(1, 2).should be_false
  end
  
  it "returns false when the score is higher for a low to high leaderboard" do
    Factory.build(:leaderboard, {:type => LeaderboardType::LowToHigh}).score_is_better?(2, 1).should be_false
  end
  
  it "returns true when the score is lower for a low to high leaderboard" do
    Factory.build(:leaderboard, {:type => LeaderboardType::LowToHigh}).score_is_better?(1, 2).should be_true
  end
  
end