class MogadeStats
  attr_accessor :dated, :scores, :achievements
  
  def self.load
    stats = MogadeStats.new
    stats.dated = Time.now
    stats.scores = Store['scores'].count
    stats.achievements = Store['earned_achievements'].count
    stats
  end
end