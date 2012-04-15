require 'spec_helper'

describe Stat, :load_data_for_year do
  before(:each) do
    date =  Time.utc(2011, 5, 10)
    4.times do |i|
      Store.redis.incrby("s:daily_hits:game_id:#{date.strftime("%y%m%d")}", i + 1000)
      Store.redis.incrby("s:daily_unique:game_id:#{date.strftime("%y%m%d")}", i + 100)
      Store.redis.incrby("s:daily_new:game_id:#{date.strftime("%y%m%d")}", i)
      date += 86400
    end
    
    date = Time.utc(2013, 5, 10)
    2.times do |i|
      Store.redis.incrby("s:daily_hits:game_id:#{date.strftime("%y%m%d")}", i + 1000)
      Store.redis.incrby("s:daily_unique:game_id:#{date.strftime("%y%m%d")}", i + 100)
      Store.redis.incrby("s:daily_new:game_id:#{date.strftime("%y%m%d")}", i)
      date += 86400
    end
    @game = FactoryGirl.build(:game, {:id => 'game_id'})
  end
  
  it "returns the stats with no custom" do
    stats = Stat.load_data_for_year(@game, '11')
    stats['110101'].should == {"game_loads"=>0, "unique_users"=>0, "new_users"=>0}
    stats['110511'].should == {"game_loads"=>1001, "unique_users"=>101, "new_users"=>1}
    stats['110512'].should == {"game_loads"=>1002, "unique_users"=>102, "new_users"=>2}
    stats['110513'].should == {"game_loads"=>1003, "unique_users"=>103, "new_users"=>3}
    stats['111231'].should == {"game_loads"=>0, "unique_users"=>0, "new_users"=>0}
  end

  it "returns the stats with custom" do
    
    date =  Time.utc(2011, 5, 10)
    2.times do |i|
      Store.redis.incrby("s:custom:game_id:1:#{date.strftime("%y%m%d")}", i + 1000)
      Store.redis.incrby("s:custom:game_id:2:#{date.strftime("%y%m%d")}", i + 100)
      Store.redis.incrby("s:custom:game_id:3:#{date.strftime("%y%m%d")}", i)
      date += 86400
    end
    @game.stats = ['1', 'two']
    stats = Stat.load_data_for_year(@game, '11')
    stats['110511'].should == {"game_loads"=>1001, "unique_users"=>101, "new_users"=>1, "1"=>1001, "two"=>101}
  end
  
end