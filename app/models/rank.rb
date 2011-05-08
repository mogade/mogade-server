class Rank
  class << self
    def save(leaderboard, scope, unique, points)
      Store.redis.zadd Rank.get_key(leaderboard, scope), points, unique
    end
    
    def get_key(leaderboard, scope)
      case scope
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