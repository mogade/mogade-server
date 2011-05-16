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
    Store['high_scores'].update({:dd => {'$lte' => Time.now.utc - 3 * 86400}}, {'$set' => {:dd => nil, :di => nil}}, {:multi => true})
    Store['high_scores'].update({:wd => {'$lte' => Time.now.utc - 10 * 86400}}, {'$set' => {:wd => nil, :wi => nil}}, {:multi => true})
    Store['scores_daily'].remove({:dt => {'$lte' => Time.now.utc - 3 * 86400}}, {:multi => true})
    Store['scores_weekly'].remove({:dt => {'$lte' => Time.now.utc - 10 * 86400}}, {:multi => true})
  end  
  
  private 
  def delete_stale_keys(keys, ttl, pattern)
    keys.each do |key|
      @redis.del(key) if Time.now.utc - Time.strptime(key.split(':')[3], pattern) > ttl
    end
  end
end