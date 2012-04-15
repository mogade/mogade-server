require 'spec_helper'

describe Stat, :hit_custom do
  before(:each) do
    @now = Time.utc(2012, 5, 10, 22, 18, 54)
    Time.stub!(:now).and_return(@now)
    
    @game = Game.new
  end
  
  it "does nothing if the index is invalid" do
    Stat.hit_custom(@game, 0)
    Stat.hit_custom(@game, 21)
    Store.redis.dbsize.should == 0
  end

  it "increases the hit counter" do
    Stat.hit_custom(@game, 1)
    Stat.hit_custom(@game, 2)
    Stat.hit_custom(@game, 2)
    Stat.hit_custom(@game, 2)
    Store.redis.get("s:custom:#{@game.id}:1:120510").should == '1'
    Store.redis.get("s:custom:#{@game.id}:2:120510").should == '3'
  end

  
end