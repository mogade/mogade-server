require 'spec_helper'
require './deploy/jobs/destroyer'

describe Destroyer, 'destroy games' do
  it "destroys the stats associated with a game" do
    game1 = FactoryGirl.build(:game, {:id => Id.new})
    game2 = FactoryGirl.build(:game, {:id => Id.new})
    old =  Time.now - 3148843
    Stat.hit(game1, 'unique1')
    Stat.hit(game2, 'unique2')
    Stat.hit(game1, 'unique2')
    Stat.hit(game1, 'unique3')
    Time.stub!(:now).and_return(old)
    Stat.hit(game1, 'unique5')
    Stat.hit(game2, 'unique3')
    
    Store.redis.sadd('cleanup:games', game1.id)
    Destroyer.new.destroy_games
    
    Store.redis.keys("*:#{game1.id}:*").length.should == 0
    Store.redis.keys("*:#{game2.id}:*").length.should == 8
  end
  
  it "destroy's a game's leaderboard" do
    game = FactoryGirl.build(:game, {:id => Id.new})
    leaderboard1 = FactoryGirl.create(:leaderboard, {:id => Id.new, :game_id => game.id})
    leaderboard2 = FactoryGirl.create(:leaderboard, {:id => Id.new, :game_id => game.id})
    leaderboard3 = FactoryGirl.create(:leaderboard, {:id => Id.new, :game_id => Id.new})
    Store.redis.sadd('cleanup:games', game.id)
    Destroyer.new.destroy_games
    
    Store['leaderboards'].count.should == 1
    Store['leaderboards'].find({:gid => game.id}).count.should == 0
  end
  
  it "removes the game id from the destruction queue" do
    game = FactoryGirl.build(:game, {:id => Id.new})
    Store.redis.sadd('cleanup:games', game.id)
    Destroyer.new.destroy_games
    Store.redis.scard('cleanup:games').should == 0
  end
  
  it "doesn't do anything if there are no game to DESTROY" do
    Destroyer.new.destroy_games
  end
end