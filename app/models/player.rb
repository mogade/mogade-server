class Player
  attr_accessor :username, :userkey
  
  def initialize(username, userkey)
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
    {LeaderboardScope::Daily => 0, LeaderboardScope::Weekly => 0, LeaderboardScope::Overall => 0}
  end
end