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
    
    def load_data(game, from, to)
      days = ((to - from)/86400).round
      days = 30 if days > 30 || days < 0
      
      date  = from
      dates = Array.new(days + 1) do
        key = date.strftime("%y%m%d")
        date += 86400
        key
      end
      redis = Store.redis
      {:from => from.utc.midnight.to_f, :days => days + 1, :data =>
        [
          redis.mget(*dates.map{|d| "s:daily_hits:#{game.id}:#{d}"}),
          redis.mget(*dates.map{|d| "s:daily_unique:#{game.id}:#{d}"}),
          redis.mget(*dates.map{|d| "s:daily_new:#{game.id}:#{d}"})
        ]
      }
    end
  end
end