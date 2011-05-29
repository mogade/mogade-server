require 'store'

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
  
  #this doesn't use indexes, so it's best to do it during non-busy times
  def clean_scores
    Store['scores'].update({'d.s' => {'$lte' => Time.now.utc - 3 * 86400}}, {'$set' => {:d => nil}}, {:multi => true})
    Store['scores'].update({'w.s' => {'$lte' => Time.now.utc - 10 * 86400}}, {'$set' => {:w => nil}}, {:multi => true})
  end  
    
  private 
  def delete_stale_keys(keys, ttl, pattern)
    keys.each do |key|
      @redis.del(key) if Time.now.utc - Time.strptime(key.split(':')[3], pattern) > ttl
    end
  end
end