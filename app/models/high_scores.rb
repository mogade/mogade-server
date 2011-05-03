# HighScore represents a quick way to get a user's potential high scores
# This removes the need to get the data from 3 separate collections (daily, weekly and overall)

# These are merely POTENTIAL high scores...the daily and weekly could be stale
# Hence the class scrubs the scores for any stale data before returning it 

# document.rb doesn't support embedded documents, need to fix that to clean this shit up
class HighScores
  include Document
  mongo_accessor({:leaderboard_id => :lid, :unique => :u, :daily_points => :dp, :daily_dated => :dd})
  
  class << self
    def load(leaderboard, player)
      scores = find_one({:leaderboard_id => leaderboard.id, :unique => player.unique}) 
      return scores.scrub(leaderboard) unless scores.nil?
      HighScores.new({:leaderboard_id => leaderboard.id, :unique => player.unique, :daily_points => 0})
    end
  end
  
  def daily
    daily_points
  end
  
  def scrub(leaderboard)
    self.daily_points = 0 if daily_dated < leaderboard.daily_start
    self
  end
end