class Rank
  class << self
    def save(leaderboard, scope, unique, points)
      Store.redis.zadd(Rank.get_key(leaderboard, scope), points, unique)
    end
    
    def get(leaderboard, unique)
      ranks = {
        :yesterday => Store.redis.zrevrank(Rank.get_key(leaderboard, LeaderboardScope::Yesterday), unique) || -1,
        :daily => Store.redis.zrevrank(Rank.get_key(leaderboard, LeaderboardScope::Daily), unique) || -1,
        :weekly => Store.redis.zrevrank(Rank.get_key(leaderboard, LeaderboardScope::Weekly), unique) || -1,
        :overall => Store.redis.zrevrank(Rank.get_key(leaderboard, LeaderboardScope::Overall), unique) || -1,
      }
      ranks.each{|k, v| ranks[k] = v + 1 }
    end
    
    def get_key(leaderboard, scope)
      case scope
      when LeaderboardScope::Yesterday
        return "#{leaderboard.id}_yesterday_#{leaderboard.yesterday_start.strftime("%Y%m%d%H")}"
      when LeaderboardScope::Overall
      when LeaderboardScope::Weekly
        return "#{leaderboard.id}_weekly_#{leaderboard.weekly_start.strftime("%Y%m%d%H")}"
      when LeaderboardScope::Overall
        return "#{leaderboard.id}_overall"
      else
        return "#{leaderboard.id}_daily_#{leaderboard.daily_start.strftime("%Y%m%d%H")}"
      end
    end
  end
end