require 'spec_helper'
require './deploy/jobs/cleaner'

describe Cleaner, 'clean rank lookups' do

  it "expires daily ranks which are older than 3 days" do
    Store.redis.zadd "lb:d:LID1:#{(Time.now - 1 * 86400).strftime('%y%m%d%H')}", 3, 'c'
    Store.redis.zadd "lb:d:LID3:#{(Time.now - 4 * 86400).strftime('%y%m%d%H')}", 1, 'a'
    Store.redis.zadd "lb:d:LID1:#{(Time.now - 3 * 86400).strftime('%y%m%d%H')}", 2, 'b'
    Store.redis.zadd "lb:d:LI51:#{(Time.now - 43434).strftime('%y%m%d%H')}", 2, 'b'
    Store.redis.zadd "lb:d:LID4:#{(Time.now - 1 * 86400).strftime('%y%m%d%H')}", 3, 'c'
    Store.redis.zadd "lb:d:LID3:#{(Time.now - 2 * 86400).strftime('%y%m%d%H')}", 3, 'c'
    Store.redis.zadd "lb:d:LID4:#{(Time.now - 5 * 86400).strftime('%y%m%d%H')}", 3, 'c'
  
    Cleaner.new.clean_rank_lookups
    
    Store.redis.dbsize.should == 4
  end
  
  it "expires weekly ranks which are older than 10 days" do
    Store.redis.zadd "lb:w:LID1:#{(Time.now - 1 * 86400).strftime('%y%m%d%H')}", 3, 'c'
    Store.redis.zadd "lb:w:LID3:#{(Time.now - 42 * 86400).strftime('%y%m%d%H')}", 1, 'a'
    Store.redis.zadd "lb:w:LID1:#{(Time.now - 9 * 86400).strftime('%y%m%d%H')}", 2, 'b'
    Store.redis.zadd "lb:w:LI51:#{(Time.now - 43434).strftime('%y%m%d%H')}", 2, 'b'
    Store.redis.zadd "lb:w:LID4:#{(Time.now - 12 * 86400).strftime('%y%m%d%H')}", 3, 'c'
    Store.redis.zadd "lb:w:LID3:#{(Time.now - 11 * 86400).strftime('%y%m%d%H')}", 3, 'c'
    Store.redis.zadd "lb:w:LID4:#{(Time.now - 10 * 86400).strftime('%y%m%d%H')}", 3, 'c'
  
    Cleaner.new.clean_rank_lookups
    
    Store.redis.dbsize.should == 3
  end
  
  it "doesn't touch overall ranks" do
    Store.redis.zadd "lb:o:LID1:#{(Time.now - 1 * 86400).strftime('%y%m%d%H')}", 3, 'c'
    Store.redis.zadd "lb:o:LID3:#{(Time.now - 42 * 86400).strftime('%y%m%d%H')}", 1, 'a'
    Store.redis.zadd "lb:o:LID1:#{(Time.now - 9 * 86400).strftime('%y%m%d%H')}", 2, 'b'
    Store.redis.zadd "lb:o:LI51:#{(Time.now - 43434).strftime('%y%m%d%H')}", 2, 'b'
    Store.redis.zadd "lb:o:LID4:#{(Time.now - 12 * 86400).strftime('%y%m%d%H')}", 3, 'c'
    Store.redis.zadd "lb:o:LID3:#{(Time.now - 11 * 86400).strftime('%y%m%d%H')}", 3, 'c'
    Store.redis.zadd "lb:o:LID4:#{(Time.now - 10 * 86400).strftime('%y%m%d%H')}", 3, 'c'
    
    Cleaner.new.clean_rank_lookups
    
    Store.redis.dbsize.should == 7
  end
end