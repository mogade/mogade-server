require 'spec_helper'

describe Rank, :rename do
  before(:each) do
    @leaderboard = FactoryGirl.build(:leaderboard)
  end

  it "does nothing if the user doesn't have a rank" do
    Rank.rename(@leaderboard, LeaderboardScope::Daily, 'old', 'new')
  end

  it "does not update other people's rank" do
    add_daily_ranks(2)
    Rank.rename(@leaderboard, LeaderboardScope::Daily, 'member3', 'new')
    ranks = Store.redis.zrange(Rank.get_key(@leaderboard, LeaderboardScope::Daily), 0, 10)
    ranks.should == ['member0', 'member1']
  end

  it "does not update other leaderboard's rank" do
    add_daily_ranks(2)
    Rank.rename(FactoryGirl.build(:leaderboard, {:id => Id.new}), LeaderboardScope::Daily, 'member1', 'new')
    ranks = Store.redis.zrange(Rank.get_key(@leaderboard, LeaderboardScope::Daily), 0, 10)
    ranks.should == ['member0', 'member1']
  end

  it "It updates the rank" do
    add_daily_ranks(2)
    Rank.rename(FactoryGirl.build(:leaderboard), LeaderboardScope::Daily, 'member1', 'new')
    ranks = Store.redis.zrange(Rank.get_key(@leaderboard, LeaderboardScope::Daily), 0, 10)
    ranks.should == ['member0', 'new']
    Store.redis.zscore(Rank.get_key(@leaderboard, LeaderboardScope::Daily), 'new').should == 1.0
  end

  private
  def add_daily_ranks(count)
    key = Rank.get_key(@leaderboard, LeaderboardScope::Daily)
    add_ranks(count, key)
  end
  def add_ranks(count, key)
    count.times do |i|
      Store.redis.zadd key, i, "member#{i}"
    end
  end
end