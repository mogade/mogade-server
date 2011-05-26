# HighScore represents a quick way to get a user's potential high scores
# This removes the need to get the data from 3 separate collections (daily, weekly and overall)

# These are merely POTENTIAL high scores...the daily and weekly could be stale
# Hence the class scrubs the scores for any stale data before returning it 

# document.rb doesn't support embedded documents, need to fix that to clean this shit up
class HighScores
  include Document
  attr_accessor :leaderboard
  mongo_accessor({:leaderboard_id => :lid, :unique => :u, :userkey => :uk, 
    :daily_points => :dp, :daily_stamp => :ds, :daily_id => :di,
    :weekly_points => :wp, :weekly_stamp => :ws, :weekly_id => :wi, 
    :overall_points => :op, :overall_id => :oi})
  
  class << self
    def load(leaderboard, player)
      scores = find_one({:leaderboard_id => leaderboard.id, :unique => player.unique}) 
      if scores.nil?
        scores = HighScores.new({:leaderboard_id => leaderboard.id, :unique => player.unique, :userkey => player.userkey, :daily_points => 0, :weekly_points => 0, :overall_points => 0})
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
  
  def daily
    daily_points
  end
  
  def weekly
    weekly_points
  end
  
  def overall
    overall_points
  end
  
  def has_new_score(points)
    changed = {}    
    changed[LeaderboardScope::Daily] = update_if_better(LeaderboardScope::Daily, points)
    changed[LeaderboardScope::Weekly] = update_if_better(LeaderboardScope::Weekly, points)
    changed[LeaderboardScope::Overall] = update_if_better(LeaderboardScope::Overall, points)
    save unless changed.blank?
    changed
  end
  
  
  def scrub!(leaderboard)
    self.daily_points = 0 if daily_stamp.nil? || daily_stamp < leaderboard.daily_stamp
    self.weekly_points = 0 if weekly_stamp.nil? || weekly_stamp < leaderboard.weekly_stamp
    self.overall_points = 0 if overall_points.nil?
    self
  end
  
  def update_if_better(scope, points)
    name = HighScores.scope_to_name(scope)
    return false unless @leaderboard.score_is_better?(points, send(name))

    Rank.save(@leaderboard, scope, unique, points)
    send("#{name}_points=", points)
    send("#{name}_stamp=", @leaderboard.send("#{name}_stamp")) if @leaderboard.respond_to?("#{name}_stamp")
    return true
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