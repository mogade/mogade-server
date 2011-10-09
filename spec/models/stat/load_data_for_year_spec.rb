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
  
  it "returns the stats" do
    stats = Stat.load_data_for_year(@game, 12)
    stats.should == {"120511"=>{"game_loads"=>"1001", "unique_users"=>"101", "new_users"=>"1"}, "120512"=>{"game_loads"=>"1002", "unique_users"=>"102", "new_users"=>"2"}, "120513"=>{"game_loads"=>"1003", "unique_users"=>"103", "new_users"=>"3"}, "120514"=>{"game_loads"=>"1004", "unique_users"=>"104", "new_users"=>"4"}, "120510"=>{"game_loads"=>"1000", "unique_users"=>"100", "new_users"=>"0"}}
  end
  
end