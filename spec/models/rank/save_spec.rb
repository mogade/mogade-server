require 'spec_helper'

describe Rank, :save do
  it "saves a daily rank" do
    leaderboard = Factory.build(:leaderboard)
    key = "#{leaderboard.id}:d:#{leaderboard.daily_start.strftime("%y%m%d%H")}"
    
    Rank.save(leaderboard, LeaderboardScope::Daily, "leto-one", 200)
    
    Store.redis.zcard(key).should == 1
    rank = Store.redis.zrange(key, 0, 1, {:with_scores => true})
    rank[0].should == "leto-one"
    rank[1].should == "200"
  end
  
  it "saves a weekly rank" do
    leaderboard = Factory.build(:leaderboard, {:offset => -4})
    key = "#{leaderboard.id}:w:#{leaderboard.weekly_start.strftime("%y%m%d%H")}"
    
    Rank.save(leaderboard, LeaderboardScope::Weekly, "paul-d", 328)
    
    Store.redis.zcard(key).should == 1
    rank = Store.redis.zrange(key, 0, 1, {:with_scores => true})
    rank[0].should == "paul-d"
    rank[1].should == "328"
  end
  
  it "saves an overall rank" do
    leaderboard = Factory.build(:leaderboard, {:offset => 6})
    key = "#{leaderboard.id}:o"
    
    Rank.save(leaderboard, LeaderboardScope::Overall, "jessica-b", 948)
    
    Store.redis.zcard(key).should == 1
    rank = Store.redis.zrange(key, 0, 1, {:with_scores => true})
    rank[0].should == "jessica-b"
    rank[1].should == "948"
  end
  
  it "overwrites a player's existing rank" do
    leaderboard = Factory.build(:leaderboard, {:offset => 6})
    key = "#{leaderboard.id}:o"
    
    Rank.save(leaderboard, LeaderboardScope::Overall, "jessica-b", 222)
    Rank.save(leaderboard, LeaderboardScope::Overall, "jessica-b", 948)
    
    Store.redis.zcard(key).should == 1
    rank = Store.redis.zrange(key, 0, 1, {:with_scores => true})
    rank[0].should == "jessica-b"
    rank[1].should == "948"
  end
end