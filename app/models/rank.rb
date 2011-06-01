class Rank
  class << self
    def save(leaderboard, scope, unique, points)
      Store.redis.zadd(Rank.get_key(leaderboard, scope), points, unique)
    end
    
    def get_for_player(leaderboard, unique, scopes = nil)
      ranks = {}
      (scopes || [LeaderboardScope::Yesterday, LeaderboardScope::Daily, LeaderboardScope::Weekly, LeaderboardScope::Overall]).each do |scope|
        if leaderboard.type == LeaderboardType::LowToHigh 
          ranks[scope] = Store.redis.zrank(Rank.get_key(leaderboard, scope), unique)
        else
          ranks[scope] = Store.redis.zrevrank(Rank.get_key(leaderboard, scope), unique)
        end
      end
      ranks.each{|k, v| ranks[k] = v.nil? ? 0 : v + 1 }
    end
    
    def get_for_score(leaderboard, score, scopes = nil)
      score = "(#{score}" #exclusive
      if scopes.nil?
        scopes = [LeaderboardScope::Yesterday, LeaderboardScope::Daily, LeaderboardScope::Weekly, LeaderboardScope::Overall]
      end
      unless scopes.is_a?(Array)
        return get_for_score_and_scope(leaderboard, score, scopes) + 1
      end
      Hash[scopes.map{|scope| [scope, get_for_score_and_scope(leaderboard, score, scope) + 1]}]
    end
    
    def get_key(leaderboard, scope)
      case scope
      when LeaderboardScope::Yesterday
        return "lb:d:#{leaderboard.id}:#{leaderboard.yesterday_stamp.strftime("%y%m%d%H")}"
      when LeaderboardScope::Weekly
        return "lb:w:#{leaderboard.id}:#{leaderboard.weekly_stamp.strftime("%y%m%d%H")}"
      when LeaderboardScope::Overall
        return "lb:o:#{leaderboard.id}"
      else
        return "lb:d:#{leaderboard.id}:#{leaderboard.daily_stamp.strftime("%y%m%d%H")}"
      end
    end
    
    private
    def get_for_score_and_scope(leaderboard, score, scope)
      if leaderboard.type == LeaderboardType::LowToHigh 
        return Store.redis.zcount(Rank.get_key(leaderboard, scope), 0, score)
      end
      return Store.redis.zcount(Rank.get_key(leaderboard, scope), score, 'inf')
    end
  end
end