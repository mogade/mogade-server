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
    
    def load_custom_data(game, ids, from, to)
      return if ids.length == 0 || ids.length > 5

      days = ((to - from)/86400).round
      days = 30 if days > 30 || days < 0
      
      date  = from
      dates = Array.new(days + 1) do
        key = date.strftime("%y%m%d")
        date += 86400
        key
      end
      redis = Store.redis
      data = Array.new(ids.length) do |index|
        redis.mget(*dates.map{|d| "s:custom:#{game.id}:#{ids[index]}:#{d}"})
      end
      {:from => from.utc.midnight.to_f, :days => days + 1, :data => data}
    end
    
    def load_data_for_year(game, year)
      real_year = 2000 + year.to_i

      start = Time.utc(real_year, 1, 1)
      stop = Time.now.utc.year == real_year ? Time.now.utc : Time.utc(real_year, 12, 31)
      
      days = (((stop - start) / 86400).to_i) + 1
      dates = []
      days.times do |i|
        dates << (start + i * 86400).strftime("%m%d")
      end

      redis = Store.redis
      data = load_one_for_year(redis, 'game_loads', "s:daily_hits:#{game.id}:#{year}", dates)
      data.deep_merge!(load_one_for_year(redis, 'unique_users', "s:daily_unique:#{game.id}:#{year}", dates))
      data.deep_merge!(load_one_for_year(redis, 'new_users', "s:daily_new:#{game.id}:#{year}", dates))
      for i in (1..Stat::CUSTOM_COUNT)
        name = game.stat_name(i-1)
        next if name.nil?
        data.deep_merge!(load_one_for_year(redis, name, "s:custom:#{game.id}:#{i}:#{year}", dates))
      end
      data
    end
    
    def load_one_for_year(redis, name, pattern, dates)
      keys = dates.map{|d| pattern + d}
      values = redis.mget(*keys)
      Hash[keys.each_with_index.map do |key, i| 
        parts = key.split(':') 
        [parts[-1], {name => values[i].to_i}]
      end]
    end
  end
end