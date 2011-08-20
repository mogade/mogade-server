require 'spec_helper'
require './deploy/jobs/cleaner'

describe Cleaner, 'shrink rank lookups' do

  it "deletes the worst ranks over the maximum for a high to low leaderboard" do
    leaderboard = FactoryGirl.create(:leaderboard, {:type => LeaderboardType::HighToLow})
    key = "lb:d:#{leaderboard.id}:#{Time.now.strftime('%y%m%d%H')}"
    10.times{|i| Store.redis.zadd key, i, i.to_s }
    
    Cleaner.new.shrink_rank_lookup(7)
    Store.redis.zcard(key).should == 7
    3.times{|i| Store.redis.zrank(key, i.to_s).should be_nil }
    7.times{|i| Store.redis.zrevrank(key, (i+3).to_s).should == (6 - i) } #it's 0-based
  end
  
  it "deletes the worst ranks over the maximum for a low to high leaderboard" do
    leaderboard = FactoryGirl.create(:leaderboard, {:type => LeaderboardType::LowToHigh})
    key = "lb:w:#{leaderboard.id}:#{Time.now.strftime('%y%m%d%H')}"
    10.times{|i| Store.redis.zadd key, i, i.to_s }
    
    Cleaner.new.shrink_rank_lookup(6)
    Store.redis.zcard(key).should == 6
    6.times{|i| Store.redis.zrank(key, i.to_s).should == i }
    4.times{|i| Store.redis.zrank(key, (i+6).to_s).should be_nil }
  end
end