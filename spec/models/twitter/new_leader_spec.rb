require 'spec_helper'

describe Twitter, :new_leader do
  scopes = [:daily, :weekly, :overall]

  it "does nothing if twitter isn't configured for the leaderboard" do
    scopes.each do |scope|
      leaderboard = FactoryGirl.build(:leaderboard)
      Twitter.send("new_#{scope}_leader".to_sym, leaderboard)
      Store.redis.exists("twitter:#{scope}").should be_false
    end
  end

  it "does nothing if the data isn't set" do
    scopes.each do |scope|
      leaderboard = FactoryGirl.build(:leaderboard)
      FactoryGirl.create(:twitter, {:leaderboard_id => leaderboard.id})
      Twitter.send("new_#{scope}_leader".to_sym, leaderboard)
      Store.redis.scard("twitter:#{scope}").should == 0
    end
  end

  it "does nothing if the interval isn't set" do
    scopes.each do |scope|
      leaderboard = FactoryGirl.build(:leaderboard)
      FactoryGirl.create(:twitter, {:leaderboard_id => leaderboard.id})
      Twitter.send("new_#{scope}_leader".to_sym, leaderboard)
      Store.redis.scard("twitter:#{scope}").should == 0
    end
  end

  it "does nothing if the leaderboard already exists" do
    scopes.each do |scope|
      leaderboard = FactoryGirl.build(:leaderboard)
      FactoryGirl.create(:twitter, {:leaderboard_id => leaderboard.id, scope => {:interval => 10}})
      Store.redis.sadd("twitter:#{scope}", leaderboard.id)
      Twitter.new_daily_leader(leaderboard)
      Store.redis.scard("twitter:#{scope}").should == 1
    end
  end

  it "adds the leaderboard" do
    scopes.each do |scope|
      leaderboard = FactoryGirl.build(:leaderboard)
      FactoryGirl.create(:twitter, {:leaderboard_id => leaderboard.id, scope => {:interval => 10}})
      Twitter.send("new_#{scope}_leader".to_sym, leaderboard)
      Store.redis.smembers("twitter:#{scope}").should == [leaderboard.id.to_s]
    end
  end
end