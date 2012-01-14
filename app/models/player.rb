class Player
  attr_accessor :username, :userkey
  
  def initialize(username = nil, userkey = nil)
    @username = username
    @userkey = userkey
  end
  
  def valid?
   !@userkey.blank? && Player.valid_username?(@username)
  end

  def self.valid_username?(username)
    !username.blank? && username.length <= 30
  end
  
  def unique
    Digest::SHA1.hexdigest(@username +  @userkey)
  end
  
  def eql?(other)
    other.is_a?(Player) && unique == other.unique
  end
  alias :== :eql?
  def hash
    unique
  end

  def rename(game, newname)
    return false unless Player.valid_username?(newname)
    oldunique = unique
    newunique = Digest::SHA1.hexdigest(newname +  @userkey)

    Achievement.find({:game_id => game.id}, {:fields => {:_id => true}, :raw => true}).each do |a|
      EarnedAchievement.update({:achievement_id => a[:_id], :unique => oldunique}, {'$set' => {:unique => newunique, :username => newname}}, {:multi => true})
    end
    Leaderboard.find({:game_id => game.id}, {:fields => {:_id => true}}).each do |leaderboard|
      leaderboard_id = leaderboard.id
      Score.update({:leaderboard_id => leaderboard_id, :unique => oldunique}, {'$set' => {:unique => newunique, :username => newname}}, {:multi => true})
      ScoreDaily.update({:leaderboard_id => leaderboard_id, :unique => oldunique}, {'$set' => {:unique => newunique, :username => newname}}, {:multi => true})
      LeaderboardScope.all_scopes.each do |scope|
        Rank.rename(leaderboard, scope, oldunique, newunique)
      end
    end
    true
  end
end