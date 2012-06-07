require 'spec_helper'

describe Twitter, :update do
  it "sets the messages and leaderboard" do
    twitter = FactoryGirl.create(:twitter)
    id = Id.new
    twitter.update('winner', 'overall winner', id)
    Twitter.count.should == 1
    found = Twitter.find_one
    found.daily_message.should == 'winner'
    found.overall_message.should == 'overall winner'
    found.leaderboard_id.should == id
  end

  it "clears the messages" do
    twitter = FactoryGirl.create(:twitter, {:daily_message => 'd', :overall_message => 'o'})
    id = Id.new
    twitter.update('', '', id)
    Twitter.count.should == 1
    found = Twitter.find_one
    found.daily_message.should be_nil
    found.overall_message.should be_nil
    found.leaderboard_id.should == id
  end
end