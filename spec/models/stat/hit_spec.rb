require 'spec_helper'

describe Stat, :hit do
  before(:each) do
    @now = Time.utc(2012, 5, 10, 22, 18, 54)
    Time.stub!(:now).and_return(@now)
    
    @game1 = Game.new
    @game2 = Game.new
  end
  
  it "increases the daily hit for each hit" do
    hit_helper(@game1, "unique", "unique3", "unique")
    hit_helper(@game2, "unique3")
    
    Store.redis.get("s:daily_hits:#{@game1.id}:#{@now.strftime("%y%m%d")}").to_i.should == 3
    Store.redis.get("s:daily_hits:#{@game2.id}:#{@now.strftime("%y%m%d")}").to_i.should == 1
  end
  
  it "increases the daily unique only for uniques for that day" do
    hit_helper(@game1, "unique", "unique", "unique2")
    now2 = Time.utc(2012, 6, 11, 22, 18, 54)
    Time.stub!(:now).and_return(now2)
    hit_helper(@game1, "unique2", "unique", "unique2", "unique3")
    
    Store.redis.get("s:daily_unique:#{@game1.id}:#{@now.strftime("%y%m%d")}").to_i.should == 2
    Store.redis.get("s:daily_unique:#{@game1.id}:#{now2.strftime("%y%m%d")}").to_i.should == 3
  end
  
  it "increases the new uinque only for truly new keys" do
    hit_helper(@game1, "unique", "unique", "unique2")
    now2 = Time.utc(2012, 6, 11, 22, 18, 54)
    Time.stub!(:now).and_return(now2)
    hit_helper(@game1, "unique2", "unique", "unique2", "unique3")
    
    Store.redis.get("s:daily_new:#{@game1.id}:#{@now.strftime("%y%m%d")}").to_i.should == 2
    Store.redis.get("s:daily_new:#{@game1.id}:#{now2.strftime("%y%m%d")}").to_i.should == 1
  end
  
  
  private
  def hit_helper(game, *uniques)
    uniques.each {|u| Stat.hit(game, u)}
  end
  
end