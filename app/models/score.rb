class Score
  include Document
  mongo_accessor({:leaderboard_id => :lid, :unique => :u, :username => :un,
                  :points => :p, :data => :d, :dated => :dt })

  class << self
    def save(leaderboard, player, points, data)
      high_scores = player.high_scores(leaderboard)
      
      selector = {:lid => leaderboard.id, :u => player.unique}
      document = {:un => player.username, :p => points, :d => data }
      options = {:upsert => true}
      
      if points > high_scores.daily
        Store.daily_collection.update(selector, document.merge({:dt => leaderboard.daily_start}), options)
      end

    end
  end
  
  def self.daily_collection
    Store['scores_daily'] 
  end
  def self.weekly_collection
    Store['scores_weekly'] 
  end
  def self.overall_collection
    Store['scores_overall'] 
  end
end