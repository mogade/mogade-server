require 'spec_helper'
require './deploy/jobs/cleaner'

describe Cleaner, 'clean statistics lookups' do

  it "deletes unique lookups older than 2 days" do
    Store.redis.sadd "s:daily_lookup:game_id1:#{(Time.now - 4 * 86400).strftime('%y%m%d')}", "leto"
    Store.redis.sadd "s:daily_lookup:game_id2:#{(Time.now - 4 * 86400).strftime('%y%m%d')}", "ghanima"
    Store.redis.sadd "s:daily_lookup:game_id1:#{(Time.now - 3 * 86400).strftime('%y%m%d')}", "paul"
    Store.redis.sadd "s:daily_lookup:game_id2:#{(Time.now - 3 * 86400).strftime('%y%m%d')}", "duncan"
    Store.redis.sadd "s:daily_lookup:game_id3:#{(Time.now - 2 * 86400).strftime('%y%m%d')}", "leto"
    Store.redis.sadd "s:daily_lookup:game_id1:#{(Time.now - 1 * 86400).strftime('%y%m%d')}", "jessica"
    Store.redis.sadd "s:daily_lookup:game_id3:#{(Time.now - 5900).strftime('%y%m%d')}", "paul"
    
    Cleaner.new.clean_statistic_lookups
    
    Store.redis.dbsize.should == 2
  end
  
end