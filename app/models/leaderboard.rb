class Leaderboard
  include MongoLight::Document
  include ActiveModel::Validations
  mongo_accessor({:game_id => :gid, :name => :n, :offset => :o, :type => :t, :mode => :m})
  
  validates_length_of :name, :minimum => 1, :maximum => 30, :allow_blank => false, :message => 'please enter a name'
  def mode
    self[:mode] || LeaderboardMode::Normal
  end
  class << self
    def find_for_game(game)
      find({:game_id => game.id}, {:sort => [:name, :ascending]}).to_a
    end
    def create(name, offset, type, mode, game)
      Leaderboard.new({:name => name, :offset => offset, :type => type, :game_id => game.id, :mode => mode})
    end
  end
  
  def score_is_better?(new_score, old_score, scope)
    return true if old_score.nil? || old_score == 0
    return true if scope == LeaderboardScope::Daily && mode == LeaderboardMode::DailyTracksLatest
    return true if mode == LeaderboardMode::AllTrackLatest
    type == LeaderboardType::LowToHigh ? new_score < old_score : new_score > old_score
  end
  
  def sort
    type == LeaderboardType::LowToHigh ? :asc : :desc
  end
  
  def score_comparer
    type == LeaderboardType::LowToHigh ? '$lt' : '$gt'
  end
  
  def daily_stamp
    now = Time.now.utc
    time = now.midnight + -3600 * (offset || 0)
    return time > now ? time - 86400 : time
  end
  
  def yesterday_stamp
    daily_stamp - 86400
  end
  
  def weekly_stamp
    now = Time.now.utc
    time = now.at_beginning_of_week + -3600 * (offset || 0)
    return time > now ? time - 604800 : time
  end
  
  def update(name, offset, type, mode)
    self.name = name
    self.offset = offset
    self.type = type
    self.mode = mode
    save!
  end

  def destroy
    Store.redis.sadd('cleanup:leaderboards', self.id)
    Leaderboard.remove({:_id => self.id})
  end
end