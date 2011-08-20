require 'spec_helper'

describe Leaderboard, :destroy do
  it "queues a cleanup in redis" do
    leaderboard = FactoryGirl.build(:leaderboard)
    leaderboard.destroy
    Store.redis.smembers('cleanup:leaderboards').should == [leaderboard.id.to_s]
  end
  
  it "deletes the leaderboard" do
    leaderboard = FactoryGirl.create(:leaderboard)
    Leaderboard.count.should == 1 #just can't help myself
    leaderboard.destroy
    Leaderboard.count.should == 0
  end
end