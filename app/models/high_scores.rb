class HighScores
  attr_accessor :player, :leaderboard
  
  def initializer(player, leaderboard)
    @player = player
    @leaderboard = leaderboard
  end
  
  def daily
    @daily || 0
  end
  
  def daily=(value)
    @daily = value
  end
  
end