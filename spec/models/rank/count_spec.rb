require 'spec_helper'

describe Rank, :count do
  it "gets the count of ranks for daily" do
    @leaderboard = FactoryGirl.build(:leaderboard)
    add_daily_ranks(10)
    Rank.count(@leaderboard, LeaderboardScope::Daily).should == 10
  end

  it "gets the count of ranks for weekly" do
    @leaderboard = FactoryGirl.build(:leaderboard)
    add_weekly_ranks(9)
    Rank.count(@leaderboard, LeaderboardScope::Weekly).should == 9
  end
  
  it "gets the count of ranks for overall" do
    @leaderboard = FactoryGirl.build(:leaderboard)
    add_overall_ranks(8)
    Rank.count(@leaderboard, LeaderboardScope::Overall).should == 8
  end

  private
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
      Store.redis.zadd key, i, "member#{i}"
    end
  end
end