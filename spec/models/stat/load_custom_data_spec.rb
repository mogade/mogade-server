require 'spec_helper'

describe Stat, :load_custom_data do
  before(:each) do
    @start = Time.utc(2012, 5, 10)
    date = @start
    5.times do |i|
      Store.redis.incrby("s:custom:game_id:1:#{date.strftime("%y%m%d")}", i + 1000)
      Store.redis.incrby("s:custom:game_id:2:#{date.strftime("%y%m%d")}", i + 100)
      Store.redis.incrby("s:custom:game_id:3:#{date.strftime("%y%m%d")}", i)
      Store.redis.incrby("s:custom:game_id:4:#{date.strftime("%y%m%d")}", i + 10000)
      Store.redis.incrby("s:custom:game_id:5:#{date.strftime("%y%m%d")}", i + 100000)
      date += 86400
    end
    @game = FactoryGirl.build(:game, {:id => 'game_id'})
  end
  
  it "returns the custom stats for the specified date" do
    stats = Stat.load_custom_data(@game, ['1', '2', '3'], @start, @start + 4 * 86400)
    stats[:data].should == [["1000", "1001", "1002", "1003", "1004"], ["100", "101", "102", "103", "104"], ["0", "1", "2", "3", "4"]]
  end
  
end