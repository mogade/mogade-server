require 'spec_helper'

describe Stat, :load_data_for_year do
  before(:each) do
    date =  Time.utc(2012, 5, 10)
    5.times do |i|
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
    stats = Stat.load_data_for_year(@game, 12)
    stats.should == {"120511"=>{"game_loads"=>"1001", "unique_users"=>"101", "new_users"=>"1"}, "120512"=>{"game_loads"=>"1002", "unique_users"=>"102", "new_users"=>"2"}, "120513"=>{"game_loads"=>"1003", "unique_users"=>"103", "new_users"=>"3"}, "120514"=>{"game_loads"=>"1004", "unique_users"=>"104", "new_users"=>"4"}, "120510"=>{"game_loads"=>"1000", "unique_users"=>"100", "new_users"=>"0"}}
  end

  it "returns the stats with custom" do
    date =  Time.utc(2012, 5, 10)
    5.times do |i|
      Store.redis.incrby("s:custom:game_id:1:#{date.strftime("%y%m%d")}", i + 1000)
      Store.redis.incrby("s:custom:game_id:2:#{date.strftime("%y%m%d")}", i + 100)
      Store.redis.incrby("s:custom:game_id:3:#{date.strftime("%y%m%d")}", i)
      date += 86400
    end
    
    date =  Time.utc(2011, 5, 10)
    2.times do |i|
      Store.redis.incrby("s:custom:game_id:1:#{date.strftime("%y%m%d")}", i + 1000)
      Store.redis.incrby("s:custom:game_id:2:#{date.strftime("%y%m%d")}", i + 100)
      Store.redis.incrby("s:custom:game_id:3:#{date.strftime("%y%m%d")}", i)
      date += 86400
    end
    
    stats = Stat.load_data_for_year(@game, 12)
    stats.should == {"120511"=>{"game_loads"=>"1001", "unique_users"=>"101", "new_users"=>"1", "1"=>"1001", "2"=>"101", "3"=>"1"}, "120512"=>{"game_loads"=>"1002", "unique_users"=>"102", "new_users"=>"2", "1"=>"1002", "2"=>"102", "3"=>"2"}, "120513"=>{"game_loads"=>"1003", "unique_users"=>"103", "new_users"=>"3", "1"=>"1003", "2"=>"103", "3"=>"3"}, "120514"=>{"game_loads"=>"1004", "unique_users"=>"104", "new_users"=>"4", "1"=>"1004", "2"=>"104", "3"=>"4"}, "120510"=>{"game_loads"=>"1000", "unique_users"=>"100", "new_users"=>"0", "1"=>"1000", "2"=>"100", "3"=>"0"}}
  end
  
end