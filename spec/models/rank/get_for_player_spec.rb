require 'spec_helper'

describe Rank, :get_for_player do
  before :each do
    @created = 0
  end

  it "gets the player's rank from yesterday for high to low" do
    @leaderboard = Factory.build(:leaderboard, {:type => LeaderboardType::HighToLow})
    add_yesterday_ranks(10)
    ranks = Rank.get_for_player(@leaderboard, 'member0', [LeaderboardScope::Yesterday])
    ranks.length.should == 1
    ranks[LeaderboardScope::Yesterday].should == 10
  end
  it "gets the player's rank from yesterday for low to high" do
    @leaderboard = Factory.build(:leaderboard, {:type => LeaderboardType::LowToHigh})
    add_yesterday_ranks(10)
    ranks = Rank.get_for_player(@leaderboard, 'member0', [LeaderboardScope::Yesterday])
    ranks.length.should == 1
    ranks[LeaderboardScope::Yesterday].should == 1
  end
  it "gets the player's daily rank for high to low" do
    @leaderboard = Factory.build(:leaderboard, {:type => LeaderboardType::HighToLow})
    add_daily_ranks(10)
    ranks = Rank.get_for_player(@leaderboard, 'member6', [LeaderboardScope::Daily])
    ranks[LeaderboardScope::Daily].should == 4
    ranks.length.should == 1
  end
  it "gets the player's daily rank for low to high" do
    @leaderboard = Factory.build(:leaderboard, {:type => LeaderboardType::LowToHigh})
    add_daily_ranks(10)
    ranks = Rank.get_for_player(@leaderboard, 'member6', [LeaderboardScope::Daily])
    ranks[LeaderboardScope::Daily].should == 7
    ranks.length.should == 1
  end
  it "gets the player's weekly rank for high to low" do
    @leaderboard = Factory.build(:leaderboard, {:type => LeaderboardType::HighToLow})
    add_weekly_ranks(10)
    ranks = Rank.get_for_player(@leaderboard, 'member7', [LeaderboardScope::Weekly])
    ranks[LeaderboardScope::Weekly].should == 3
    ranks.length.should == 1
  end
  it "gets the player's weekly rank for low to high" do
    @leaderboard = Factory.build(:leaderboard, {:type => LeaderboardType::LowToHigh})
    add_weekly_ranks(10)
    ranks = Rank.get_for_player(@leaderboard, 'member7', [LeaderboardScope::Weekly])
    ranks[LeaderboardScope::Weekly].should == 8
    ranks.length.should == 1
  end
  it "gets the player's overall rank for high to low" do
    @leaderboard = Factory.build(:leaderboard, {:type => LeaderboardType::HighToLow})
    add_overall_ranks(10)
    ranks = Rank.get_for_player(@leaderboard, 'member9', [LeaderboardScope::Overall])
    ranks[LeaderboardScope::Overall].should == 1
    ranks.length.should == 1
  end
  it "gets the player's overall rank for low to high" do
    @leaderboard = Factory.build(:leaderboard, {:type => LeaderboardType::LowToHigh})
    add_overall_ranks(10)
    ranks = Rank.get_for_player(@leaderboard, 'member9', [LeaderboardScope::Overall])
    ranks[LeaderboardScope::Overall].should == 10
    ranks.length.should == 1
  end
  it "returns 0 if the user has no rank" do
    @leaderboard = Factory.build(:leaderboard)
    ranks = Rank.get_for_player(@leaderboard, 'memberX')
    ranks[LeaderboardScope::Yesterday].should == 0
    ranks[LeaderboardScope::Daily].should == 0
    ranks[LeaderboardScope::Weekly].should == 0
    ranks[LeaderboardScope::Overall].should == 0
  end 
  
  private
  def add_yesterday_ranks(count)
    key = Rank.get_key(@leaderboard, LeaderboardScope::Yesterday)
    add_ranks(count, key)
  end
  def add_daily_ranks(count)
    key = Rank.get_key(@leaderboard, LeaderboardScope::Daily)
    add_ranks(count, key)
  end
  def add_weekly_ranks(count)
    key = Rank.get_key(@leaderboard, LeaderboardScope::Weekly)
    add_ranks(count, key)
  end
  def add_overall_ranks(count)
    key = Rank.get_key(@leaderboard, LeaderboardScope::Overall)
    add_ranks(count, key)
  end
  def add_ranks(count, key)
    count.times do |i|
      Store.redis.zadd key, @created, "member#{@created}"
      @created += 1
    end
  end
end