require 'spec_helper'

describe Twitter, :update_message do
  it "removes the message" do
    twitter = FactoryGirl.create(:twitter, :daily => TwitterData.new, :weekly => TwitterData.new, :overall => TwitterData.new)
    twitter.daily.messages = ['a', 'b', 'c']
    twitter.weekly.messages = ['x', 'y', 'z']
    twitter.overall.messages = ['1', '2', '3']
    twitter.save!

    twitter.update_message(LeaderboardScope::Daily, 1, 'zz')
    twitter.update_message(LeaderboardScope::Weekly, 2, 'bb')
    twitter.update_message(LeaderboardScope::Overall, 0, 'cc')

    found = Twitter.find_one
    found.daily.messages.should == ['a', 'zz', 'c']
    found.weekly.messages.should == ['x', 'y', 'bb']
    found.overall.messages.should == ['cc', '2', '3']
  end
end