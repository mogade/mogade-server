require 'spec_helper'
require './deploy/jobs/cleaner'

describe Cleaner, 'clean statistics lookups' do

  it "deletes unique lookups older than 8 days" do
    Store.redis.sadd "s:daily_lookup:game_id1:#{(Time.now - 10 * 86400).strftime('%y%m%d')}", "leto"
    Store.redis.sadd "s:daily_lookup:game_id2:#{(Time.now - 10 * 86400).strftime('%y%m%d')}", "ghanima"
    Store.redis.sadd "s:daily_lookup:game_id1:#{(Time.now - 9 * 86400).strftime('%y%m%d')}", "paul"
    Store.redis.sadd "s:daily_lookup:game_id2:#{(Time.now - 9 * 86400).strftime('%y%m%d')}", "duncan"
    Store.redis.sadd "s:daily_lookup:game_id3:#{(Time.now - 8 * 86400).strftime('%y%m%d')}", "leto"
    Store.redis.sadd "s:daily_lookup:game_id1:#{(Time.now - 7 * 86400).strftime('%y%m%d')}", "jessica"
    Store.redis.sadd "s:daily_lookup:game_id3:#{(Time.now - 5900).strftime('%y%m%d')}", "paul"
    
    Cleaner.new.clean_statistic_lookups
    
    Store.redis.dbsize.should == 2
  end
  
end