require 'spec_helper'

describe Rank, :get do
  before :each do
    @created = 0
  end

  it "gets the player's rank from yesterday" do
    @leaderboard = Factory.build(:leaderboard)
    add_yesterday_ranks(10)
    ranks = Rank.get(@leaderboard, 'member0', [LeaderboardScope::Yesterday])
    ranks.length.should == 1
    ranks[LeaderboardScope::Yesterday].should == 10
  end
  it "gets the player's daily rank" do
    @leaderboard = Factory.build(:leaderboard)
    add_daily_ranks(10)
    ranks = Rank.get(@leaderboard, 'member6', [LeaderboardScope::Daily])
    ranks[LeaderboardScope::Daily].should == 4
    ranks.length.should == 1
  end
  it "gets the player's weekly rank" do
    @leaderboard = Factory.build(:leaderboard)
    add_weekly_ranks(10)
    ranks = Rank.get(@leaderboard, 'member7', [LeaderboardScope::Weekly])
    ranks[LeaderboardScope::Weekly].should == 3
    ranks.length.should == 1
  end
  it "gets the player's overall rank" do
    @leaderboard = Factory.build(:leaderboard)
    add_overall_ranks(10)
    ranks = Rank.get(@leaderboard, 'member9', [LeaderboardScope::Overall])
    ranks[LeaderboardScope::Overall].should == 1
    ranks.length.should == 1
  end
  it "returns 0 if the user has no rank" do
    @leaderboard = Factory.build(:leaderboard)
    ranks = Rank.get(@leaderboard, 'memberX')
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