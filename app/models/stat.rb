class Stat
  CUSTOM_COUNT = 20
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
    
    def hit_custom(game, index)
      return unless index > 0 && index <= Stat::CUSTOM_COUNT
      Store.redis.incr("s:custom:#{game.id}:#{index}:#{Time.now.utc.strftime("%y%m%d")}")
    end
    
    def weekly_unique(game)
      redis = Store.redis
      now = Time.now.utc
      keys = Array.new(7) do |i| 
        time = (now - (i*86400)).strftime("%y%m%d")
        "s:daily_lookup:#{game.id}:#{time}"
      end
      redis.sunion(*keys).length
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
    
    def load_custom_data(game, from, to)
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
          redis.mget(*dates.map{|d| "s:custom:#{game.id}:1:#{d}"}),
          redis.mget(*dates.map{|d| "s:custom:#{game.id}:2:#{d}"}),
          redis.mget(*dates.map{|d| "s:custom:#{game.id}:3:#{d}"}),
          redis.mget(*dates.map{|d| "s:custom:#{game.id}:4:#{d}"}),
          redis.mget(*dates.map{|d| "s:custom:#{game.id}:5:#{d}"})
        ]
      }
    end
    
    def load_data_for_year(game, year)
      redis = Store.redis
      data = load_one_for_year(redis, 'game_loads', "s:daily_hits:#{game.id}:#{year}*")
      data.deep_merge!(load_one_for_year(redis, 'unique_users', "s:daily_unique:#{game.id}:#{year}*"))
      data.deep_merge!(load_one_for_year(redis, 'new_users', "s:daily_new:#{game.id}:#{year}*"))
      data.deep_merge!(load_one_for_year(redis, game.stat_name(0), "s:custom:#{game.id}:1:#{year}*"))
      data.deep_merge!(load_one_for_year(redis, game.stat_name(1), "s:custom:#{game.id}:2:#{year}*"))
      data.deep_merge!(load_one_for_year(redis, game.stat_name(2), "s:custom:#{game.id}:3:#{year}*"))
      data.deep_merge!(load_one_for_year(redis, game.stat_name(3), "s:custom:#{game.id}:4:#{year}*"))
      data.deep_merge!(load_one_for_year(redis, game.stat_name(4), "s:custom:#{game.id}:5:#{year}*"))
      data
    end
    
    def load_one_for_year(redis, name, pattern)
      keys = redis.keys(pattern)
      return {} if keys.blank?
      values = redis.mget(*keys)
      Hash[keys.each_with_index.map do |key, i| 
        parts = key.split(':') 
        [parts[-1], {name => values[i]}]
      end]
    end
  end
end