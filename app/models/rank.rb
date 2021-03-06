class Rank
  class << self
    def save(leaderboard, scope, unique, points)
      Store.redis.zadd(Rank.get_key(leaderboard, scope), points, unique)
    end

    def rename(leaderboard, scope, oldunique, newunique)
      key = Rank.get_key(leaderboard, scope)
      redis = Store.redis
      score = redis.zscore(key, oldunique)
      return if score.nil?

      redis.zrem(key, oldunique)
      redis.zadd(key, score, newunique)
    end
    
    def count(leaderboard, scope)
      Store.redis.zcard(Rank.get_key(leaderboard, scope))
    end
    
    def get_for_player(leaderboard, unique, scopes = nil)
      score = "(#{score}" #exclusive
      scopes = LeaderboardScope::all_scopes if scopes.nil?
      unless scopes.is_a?(Array)
        return get_for_player_and_scope(leaderboard, unique, scopes)
      end
      Hash[scopes.map{|scope| [scope, get_for_player_and_scope(leaderboard, unique, scope)]}]
    end
    
    def get_for_score(leaderboard, score, scopes = nil)
      score = "(#{score}" #exclusive
      scopes = LeaderboardScope::all_scopes if scopes.nil?
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
    def get_for_player_and_scope(leaderboard, unique, scope)
      if leaderboard.type == LeaderboardType::LowToHigh 
        rank = Store.redis.zrank(Rank.get_key(leaderboard, scope), unique)
      else
        rank = Store.redis.zrevrank(Rank.get_key(leaderboard, scope), unique)
      end
      return rank.nil? ? 0 : rank + 1
    end
    def get_for_score_and_scope(leaderboard, score, scope)
      if leaderboard.type == LeaderboardType::LowToHigh 
        return Store.redis.zcount(Rank.get_key(leaderboard, scope), 0, score)
      end
      return Store.redis.zcount(Rank.get_key(leaderboard, scope), score, 'inf')
    end
  end
end