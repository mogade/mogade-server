class Stat
  class << self
    def hit(game, userkey)
      redis = Store.redis
      key_stamp = "#{game.id}:#{Time.now.utc.strftime("%y%m%d")}"
      redis.incr("s:daily_hits:#{key_stamp}")
      if redis.sadd("s:daily_lookup:#{key_stamp}", userkey)
        redis.incr("s:daily_unique:#{key_stamp}")
      end
      if redis.sadd("s:lookup:#{game.id}", userkey)
        redis.incr("s:daily_new:#{key_stamp}")
      end
    end
  end
end