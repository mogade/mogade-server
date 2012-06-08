require 'spec_helper'

describe Twitter, :update_message do
  it "removes the message" do
    twitter = FactoryGirl.create(:twitter, :daily => TwitterData.new, :weekly => TwitterData.new, :overall => TwitterData.new)
    twitter.daily.messages = ['a', 'b', 'c']
    twitter.weekly.messages = ['x', 'y', 'z']
    twitter.overall.messages = ['1', '2', '3']
    twitter.save!

    twitter.update_message(LeaderboardScope::Daily, LeaderboardScope::Daily, 1, 'zz')
    twitter.update_message(LeaderboardScope::Weekly, LeaderboardScope::Daily, 2, 'bb')
    twitter.update_message(LeaderboardScope::Overall, LeaderboardScope::Weekly, 0, 'cc')

    found = Twitter.find_one
    found.daily.messages.should == ['a', 'c', 'zz', 'bb']
    found.weekly.messages.should == ['x', 'y', 'cc']
    found.overall.messages.should == ['2', '3']
  end
end