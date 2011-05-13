class Leaderboard
  include Document
  mongo_accessor({:game_id => :gid, :name => :name, :offset => :offset, :type => :t})
  
  def score_is_better?(new_score, old_score)
    type == LeaderboardType::LowToHigh ? new_score < old_score : new_score > old_score
  end
  
  def sort
    type == LeaderboardType::LowToHigh ? :asc : :desc
  end
  
  def daily_start
    now = Time.now.utc
    time = now.midnight + -3600 * offset
    return time > now ? time - 86400 : time
  end
  
  def yesterday_start
    daily_start - 86400
  end
  
  def weekly_start
    now = Time.now.utc
    time = now.at_beginning_of_week + -3600 * offset
    return time > now ? time - 604800 : time
  end
end