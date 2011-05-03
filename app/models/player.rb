class Player
  attr_accessor :username, :userkey
  
  def initialize(username = nil, userkey = nil)
    @username = username
    @userkey = userkey
  end
  
  def valid?
    !@username.blank? && !@userkey.blank? && @username.length <= 30
  end
  
  def unique
    Digest::SHA1.hexdigest(@username +  @userkey)
  end
  
  def high_scores(leaderboard)
    HighScores.load(leaderboard, self)
  end
end