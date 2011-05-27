class Leaderboard
  include Document
  include ActiveModel::Validations
  mongo_accessor({:game_id => :gid, :name => :n, :offset => :o, :type => :t})
  
  validates_length_of :name, :minimum => 1, :maximum => 30, :allow_blank => false, :message => 'please enter a name'
  
  class << self
    def find_for_game(game)
      find({:game_id => game.id}, {:sort => [:name, :ascending]}).to_a
    end
    def create(name, offset, type, game)
      Leaderboard.new({:name => name, :offset => offset, :type => type, :game_id => game.id})
    end
  end
  
  def score_is_better?(new_score, old_score)
    return true if old_score.nil?
    type == LeaderboardType::LowToHigh ? new_score < old_score : new_score > old_score
  end
  
  def sort
    type == LeaderboardType::LowToHigh ? :asc : :desc
  end
  
  def daily_stamp
    now = Time.now.utc
    time = now.midnight + -3600 * offset
    return time > now ? time - 86400 : time
  end
  
  def yesterday_stamp
    daily_stamp - 86400
  end
  
  def weekly_stamp
    now = Time.now.utc
    time = now.at_beginning_of_week + -3600 * offset
    return time > now ? time - 604800 : time
  end
  
  def update(name, offset, type)
    self.name = name
    self.offset = offset
    self.type = type
    save!
  end

  def destroy
    Store.redis.sadd('cleanup:leaderboards', self.id)
    Leaderboard.remove({:_id => self.id})
  end
end