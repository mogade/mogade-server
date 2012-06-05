require 'spec_helper'

describe Twitter, :update do
  it "sets the message and leaderboard" do
    twitter = FactoryGirl.create(:twitter)
    id = Id.new
    twitter.update('winner', id)
    Twitter.count.should == 1
    found = Twitter.find_one
    twitter.message.should == 'winner'
    twitter.leaderboard_id.should == id
  end
end