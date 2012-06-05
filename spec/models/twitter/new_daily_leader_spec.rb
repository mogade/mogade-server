require 'spec_helper'

describe Twitter, :new_daily_leader do
  it "does nothing if twitter isn't configured for the leaderboard" do
    leaderboard = FactoryGirl.build(:leaderboard)
    Twitter.new_daily_leader(leaderboard)
    Store.redis.exists("twitter:daily:lookup").should be_false
    Store.redis.exists("twitter:daily").should be_false
  end

  it "does nothing if the leaderboard already exists" do
    leaderboard = FactoryGirl.build(:leaderboard)
    FactoryGirl.create(:twitter, {:leaderboard_id => leaderboard.id})
    Store.redis.sadd("twitter:daily:lookup", leaderboard.id)
    Twitter.new_daily_leader(leaderboard)
    Store.redis.scard("twitter:daily:lookup").should == 1
    Store.redis.exists("twitter:daily").should be_false
  end

  it "Adds the leaderboard" do
    leaderboard = FactoryGirl.build(:leaderboard)
    FactoryGirl.create(:twitter, {:leaderboard_id => leaderboard.id})
    Twitter.new_daily_leader(leaderboard)
    Store.redis.smembers("twitter:daily:lookup").should == [leaderboard.id.to_s]
    Store.redis.lrange("twitter:daily", 0, 10).should == [leaderboard.id.to_s]
  end
end