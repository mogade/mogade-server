require 'store.rb'

class Cleaner
  
  def initialize
    @redis = Store.redis
  end
  
  def clean_statistic_lookups
    delete_stale_keys(@redis.keys('s:daily_lookup:*'), 2 * 86400, '%y%m%d')
  end
  
  def clean_rank_lookups
    delete_stale_keys(@redis.keys('lb:d:*'), 3 * 86400, '%y%m%d%H')
    delete_stale_keys(@redis.keys('lb:w:*'), 10 * 86400, '%y%m%d%H')
  end
  
  def shrink_rank_lookup(max)
    @redis.keys('lb:*').each do |key|
      lid = key.split(':')[2]
      count = @redis.zcard(key)
      if count > max
        type = Store['leaderboards'].find_one({:_id => BSON::ObjectId.from_string(lid)})['t']
        if type == 1
          @redis.zremrangebyrank(key, 0, count - max - 1)
        else
          @redis.zremrangebyrank(key, max, count)
        end
      end
    end
  end
  
  #this doesn't use indexes, so it's best to do it during non-busy times
  def clean_scores
    Store['scores'].update({'d.s' => {'$lte' => Time.now.utc - 3 * 86400}}, {'$set' => {:d => nil}}, {:multi => true})
    Store['scores'].update({'w.s' => {'$lte' => Time.now.utc - 10 * 86400}}, {'$set' => {:w => nil}}, {:multi => true})
    Store['score_dailies'].remove({:s => {'$lte' => Time.now.utc - 3 * 86400}})
  end  
    
  private 
  def delete_stale_keys(keys, ttl, pattern)
    keys.each do |key|
      @redis.del(key) if Time.now.utc - Date.strptime(key.split(':')[3], pattern).to_time > ttl
    end
  end
end