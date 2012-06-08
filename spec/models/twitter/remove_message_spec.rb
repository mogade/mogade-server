require 'spec_helper'

describe Twitter, :remove_message do
  it "removes the message" do
    twitter = FactoryGirl.create(:twitter, :daily => TwitterData.new, :weekly => TwitterData.new, :overall => TwitterData.new)
    twitter.daily.messages = ['a', 'b', 'c']
    twitter.weekly.messages = ['x', 'y', 'z']
    twitter.overall.messages = ['1', '2', '3']
    twitter.save!

    twitter.remove_message(LeaderboardScope::Daily, 1)
    twitter.remove_message(LeaderboardScope::Weekly, 2)
    twitter.remove_message(LeaderboardScope::Overall, 0)

    found = Twitter.find_one
    found.daily.messages.should == ['a', 'c']
    found.weekly.messages.should == ['x', 'y']
    found.overall.messages.should == ['2', '3']
  end
end