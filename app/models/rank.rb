class Rank
  class << self
    def save(leaderboard, scope, unique, points)
      Store.redis.zadd(Rank.get_key(leaderboard, scope), points, unique)
    end
    
    def get(leaderboard, unique, scopes = nil)
      ranks = {}
      (scopes || [LeaderboardScope::Yesterday, LeaderboardScope::Daily, LeaderboardScope::Weekly, LeaderboardScope::Overall]).each do |scope|
        #todo fix
        if leaderboard.type == LeaderboardType::LowToHigh 
          ranks[scope] = Store.redis.zrank(Rank.get_key(leaderboard, scope), unique) || -1
        else
          ranks[scope] = Store.redis.zrevrank(Rank.get_key(leaderboard, scope), unique) || -1
        end
      end
      ranks.each{|k, v| ranks[k] = v + 1 }
    end
    
    def get_key(leaderboard, scope)
      case scope
      when LeaderboardScope::Yesterday
        return "lb:d:#{leaderboard.id}:#{leaderboard.yesterday_start.strftime("%y%m%d%H")}"
      when LeaderboardScope::Weekly
        return "lb:w:#{leaderboard.id}:#{leaderboard.weekly_start.strftime("%y%m%d%H")}"
      when LeaderboardScope::Overall
        return "lb:o:#{leaderboard.id}"
      else
        return "lb:d:#{leaderboard.id}:#{leaderboard.daily_start.strftime("%y%m%d%H")}"
      end
    end
  end
end