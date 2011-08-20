require 'spec_helper'

describe Leaderboard, :sort do
  
  it "returns descending for high to low" do
    FactoryGirl.build(:leaderboard, {:type => LeaderboardType::HighToLow}).sort.should == :desc
  end
  
  it "returns ascending for lowt to high" do
    FactoryGirl.build(:leaderboard, {:type => LeaderboardType::LowToHigh}).sort.should == :asc
  end


end