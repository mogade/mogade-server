require 'spec_helper'

describe Twitter, :add_message do
  it "returns false if there are too many messages already" do
    twitter = FactoryGirl.create(:twitter, :daily => TwitterData.new, :weekly => TwitterData.new, :overall => TwitterData.new)
    [:daily, :weekly, :overall].each do |scope|
      10.times do |i|
        data = twitter.send(scope)
        data.messages = [] if data.messages.nil?
        data.messages << i
      end
    end
    twitter.save

    twitter.add_message(2, 'fail').should be_false
    Twitter.find_one.message_count.should == 30
  end

  it "adds the message" do
    twitter = FactoryGirl.create(:twitter, :daily => TwitterData.new, :weekly => TwitterData.new, :overall => TwitterData.new)
    [1, 2, 3].each do |scope|
      twitter.add_message(scope, "message for #{scope}").should be_true
    end
    found = Twitter.find_one
    found.daily.messages.should == ['message for 1']
    found.weekly.messages.should == ['message for 2']
    found.overall.messages.should == ['message for 3']
  end
end