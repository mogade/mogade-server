# HighScore represents a quick way to get a user's potential high scores
# This removes the need to get the data from 3 separate collections (daily, weekly and overall)

# These are merely POTENTIAL high scores...the daily and weekly could be stale
# Hence the class scrubs the scores for any stale data before returning it 
class HighScores
  include Document
  attr_accessor :leaderboard
  mongo_accessor({:leaderboard_id => :lid, :unique => :u, :userkey => :uk, 
    :daily => {:field => :d, :class => HighScore},
    :weekly => {:field => :w, :class => HighScore},
    :overall => {:field => :o, :class => HighScore}})
  
  class << self
    def load(leaderboard, player)
      scores = find_one({:leaderboard_id => leaderboard.id, :unique => player.unique}) 
      if scores.nil?
        scores = HighScores.new({:leaderboard_id => leaderboard.id, :unique => player.unique, :userkey => player.userkey, :daily => HighScore.blank, :weekly => HighScore.blank, :overall => HighScore.blank})
      else
        scores.scrub!(leaderboard)
      end
      scores.leaderboard = leaderboard
      scores
    end
    
    def find_for_player(game, player)
      leaderboards = Leaderboard.find({:game_id => game.id})
      leaderboards.map{|leaderboard| HighScores.load(leaderboard, player)}
    end
  end
  
  def has_new_score(points, data)
    changed = {}    
    changed[LeaderboardScope::Daily] = update_if_better(LeaderboardScope::Daily, points, data)
    changed[LeaderboardScope::Weekly] = update_if_better(LeaderboardScope::Weekly, points, data)
    changed[LeaderboardScope::Overall] = update_if_better(LeaderboardScope::Overall, points, data)
    save unless changed.blank?
    changed
  end
  
  
  def scrub!(leaderboard)
    self.daily.points = 0 if daily.stamp.nil? || daily.stamp < leaderboard.daily_stamp
    self.weekly.points = 0 if weekly.stamp.nil? || weekly.stamp < leaderboard.weekly_stamp
    self.overall.points = 0 if overall.points.nil?
    self
  end
  
  def update_if_better(scope, points, data)
    name = HighScores.scope_to_name(scope)
    return false unless @leaderboard.score_is_better?(points, send(name).points)

    Rank.save(@leaderboard, scope, unique, points)
    score = send("#{name}")
    score.points = points
    score.stamp = @leaderboard.send("#{name}_stamp") if @leaderboard.respond_to?("#{name}_stamp")
    score.data = data
    return true
  end
  
  def for_scope(scope)
    case scope
    when LeaderboardScope::Weekly
      return weekly
    when LeaderboardScope::Overall
      return overall
    else
      return daily
    end
  end
  
  private
  def self.scope_to_name(scope)
    case scope
    when LeaderboardScope::Weekly
      return :weekly
    when LeaderboardScope::Overall
      return :overall
    else
      return :daily
    end
  end
end