class Rank
  class << self
    def save(leaderboard, scope, unique, points)
      Store.redis.zadd(Rank.get_key(leaderboard, scope), points, unique)
    end
    
    def get(leaderboard, unique, scopes = nil)
      ranks = {}
      (scopes || [LeaderboardScope::Yesterday, LeaderboardScope::Daily, LeaderboardScope::Weekly, LeaderboardScope::Overall]).each do |scope|
        ranks[scope] = Store.redis.zrevrank(Rank.get_key(leaderboard, scope), unique) || -1
      end
      ranks.each{|k, v| ranks[k] = v + 1 }
    end
    
    def get_key(leaderboard, scope)
      case scope
      when LeaderboardScope::Yesterday
        return "#{leaderboard.id}_y_#{leaderboard.yesterday_start.strftime("%Y%m%d%H")}"
      when LeaderboardScope::Weekly
        return "#{leaderboard.id}_w_#{leaderboard.weekly_start.strftime("%Y%m%d%H")}"
      when LeaderboardScope::Overall
        return "#{leaderboard.id}_o"
      else
        return "#{leaderboard.id}_d_#{leaderboard.daily_start.strftime("%Y%m%d%H")}"
      end
    end
  end
end