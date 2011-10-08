require 'spec_helper'

describe Stat, :weekly_unique do
  
  before(:each) do
    date =  Time.utc(2012, 5, 10)
    @game = FactoryGirl.build(:game, {:id => 'game_id'})
    Time.stub!(:now).and_return(date)
  end
  
  it "returns the weekly unique count" do
    Store.redis.sadd("s:daily_lookup:game_id:120510", "a")
    Store.redis.sadd("s:daily_lookup:game_id:120510", "b")
    Store.redis.sadd("s:daily_lookup:game_id:120509", "a")
    Store.redis.sadd("s:daily_lookup:game_id:120508", "c")
    Store.redis.sadd("s:daily_lookup:game_id:120507", "a")
    Store.redis.sadd("s:daily_lookup:game_id:120506", "z")
    Store.redis.sadd("s:daily_lookup:game_id:120505", "z")
    Store.redis.sadd("s:daily_lookup:game_id:120504", "b")
    
    Stat.weekly_unique(@game).should == 4
  end
  
end