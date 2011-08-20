require 'spec_helper'

describe Stat, :load_data do
  before(:each) do
    @start = Time.utc(2012, 5, 10)
    date = @start
    5.times do |i|
      Store.redis.incrby("s:daily_hits:game_id:#{date.strftime("%y%m%d")}", i + 1000)
      Store.redis.incrby("s:daily_unique:game_id:#{date.strftime("%y%m%d")}", i + 100)
      Store.redis.incrby("s:daily_new:game_id:#{date.strftime("%y%m%d")}", i)
      date += 86400
    end
    @game = FactoryGirl.build(:game, {:id => 'game_id'})
  end
  
  it "returns the number of daily hits for the specified date range" do
    stats = Stat.load_data(@game, @start, @start + 4 * 86400)
    stats[:data][0][0].should == '1000'
    stats[:data][0][1].should == '1001'
    stats[:data][0][2].should == '1002'
    stats[:data][0][3].should == '1003'
  end
  
  it "returns the number of unique daily hits for the specified date range" do
    stats = Stat.load_data(@game, @start, @start + 3 * 86400)
    stats[:data][1][0].should == '100'
    stats[:data][1][1].should == '101'
    stats[:data][1][2].should == '102'
  end
  
  it "returns the number of new hits for the specified date range" do
    stats = Stat.load_data(@game, @start, @start + 3 * 86400)
    stats[:data][2][0].should == '0'
    stats[:data][2][1].should == '1'
    stats[:data][2][2].should == '2'
  end
  
  it "returns the number of days" do
    stats = Stat.load_data(@game, @start, @start + 3 * 86400)
    stats[:days].should == 4
    stats[:data].each{|d| d.length.should == 4 }
  end
  
  it "limits the stats to 31 days" do
    stats = Stat.load_data(@game, @start, @start + 40 * 86400)
    stats[:days].should == 31
    stats[:data].each{|d| d.length.should == 31 }
  end
  
  it "returns the start date" do
    stats = Stat.load_data(@game, @start, @start + 40 * 86400)
    stats[:from].should == @start.to_f
  end
end