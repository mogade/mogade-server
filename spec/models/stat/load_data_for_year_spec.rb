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
    stats.should == {"120511"=>{"daily_hits"=>"1001", "daily_unique"=>"101", "daily_new"=>"1"}, "120512"=>{"daily_hits"=>"1002", "daily_unique"=>"102", "daily_new"=>"2"}, "120513"=>{"daily_hits"=>"1003", "daily_unique"=>"103", "daily_new"=>"3"}, "120514"=>{"daily_hits"=>"1004", "daily_unique"=>"104", "daily_new"=>"4"}, "120510"=>{"daily_hits"=>"1000", "daily_unique"=>"100", "daily_new"=>"0"}}
  end
  
end