require 'spec_helper'

describe Game, :destroy do
  it "queues a cleanup in redis" do
    game = Factory.build(:game)
    game.destroy
    Store.redis.smembers('cleanup:games').should == [game.id.to_s]
  end
  
  it "deletes the game" do
    game = Factory.create(:game)
    Game.count.should == 1 #just can't help myself
    game.destroy
    Game.count.should == 0
  end
end