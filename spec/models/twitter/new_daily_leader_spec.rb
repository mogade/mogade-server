require 'spec_helper'

describe Twitter, :new_daily_leader do
  it "does nothing if twitter isn't configured for the leaderboard" do
    leaderboard = FactoryGirl.build(:leaderboard)
    Twitter.new_daily_leader(leaderboard)
    Store.redis.exists("twitter:daily").should be_false
  end

  it "does nothing if daily_message isn't set" do
    leaderboard = FactoryGirl.build(:leaderboard)
    FactoryGirl.create(:twitter, {:leaderboard_id => leaderboard.id})
    Twitter.new_daily_leader(leaderboard)
    Store.redis.scard("twitter:daily").should == 0
  end

  it "does nothing if the leaderboard already exists" do
    leaderboard = FactoryGirl.build(:leaderboard)
    FactoryGirl.create(:twitter, {:leaderboard_id => leaderboard.id, :daily_message => 't-m'})
    Store.redis.sadd("twitter:daily", leaderboard.id)
    Twitter.new_daily_leader(leaderboard)
    Store.redis.scard("twitter:daily").should == 1
  end

  it "adds the leaderboard" do
    leaderboard = FactoryGirl.build(:leaderboard)
    FactoryGirl.create(:twitter, {:leaderboard_id => leaderboard.id, :daily_message => 'message'})
    Twitter.new_daily_leader(leaderboard)
    Store.redis.smembers("twitter:daily").should == [leaderboard.id.to_s]
  end
end