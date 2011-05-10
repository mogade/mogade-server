require 'store'


class Cleaner
  
  def initialize
    @redis = Store.redis
  end
  
  def clean_rank_lookups
    delete_stale_keys(@redis.keys('lb:d:*'), 3 * 86400)
    delete_stale_keys(@redis.keys('lb:w:*'), 10 * 86400)
  end
    
  private 
  def delete_stale_keys(keys, ttl)
    keys.each do |key|
      @redis.del(key) if Time.now.utc - Time.strptime(key.split(':')[3], '%y%m%d%H') > ttl
    end
  end
end