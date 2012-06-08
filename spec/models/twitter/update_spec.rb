require 'spec_helper'

describe Twitter, :update do
  it "sets the leaderboard" do
    twitter = FactoryGirl.create(:twitter)
    id = Id.new
    twitter.update({:leaderboard_id => id.to_s})
    Twitter.count.should == 1
    found = Twitter.find_one
    found.leaderboard_id.should == id
  end

  it "updates the intervals for all scopes" do
    twitter = FactoryGirl.create(:twitter)
    twitter.update({:leaderboard_id => Id.new.to_s, :daily => {:interval => 20}, :weekly => {:interval => 25}, :overall => {:interval => 30}})
    Twitter.count.should == 1
    found = Twitter.find_one
    found.daily.interval.should == 20
    found.weekly.interval.should == 25
    found.overall.interval.should == 30
  end

  it "defaults missing intervals to 0" do
    twitter = FactoryGirl.create(:twitter)
    twitter.update({:leaderboard_id => Id.new.to_s, :daily => {}, :weekly => {}, :overall => {}})
    Twitter.count.should == 1
    found = Twitter.find_one
    found.daily.interval.should == 0
    found.weekly.interval.should == 0
    found.overall.interval.should == 0
  end

   it "does not allow intervals below 10" do
    twitter = FactoryGirl.create(:twitter)
    twitter.update({:leaderboard_id => Id.new.to_s, :daily => {:interval => 8}, :weekly => {:interval => 7}, :overall => {:interval => 9}})
    Twitter.count.should == 1
    found = Twitter.find_one
    found.daily.interval.should == 10
    found.weekly.interval.should == 10
    found.overall.interval.should == 10
  end
end