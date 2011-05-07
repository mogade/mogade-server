class Score
  include Document
  mongo_accessor({:leaderboard_id => :lid, :unique => :u, :username => :un,
                  :points => :p, :data => :d, :dated => :dt })

  class << self
    def save(leaderboard, player, points, data = nil)
      high_scores = player.high_scores(leaderboard)
      
      selector = {:lid => leaderboard.id, :u => player.unique}
      document = selector.merge({:un => player.username[0..19], :p => points})
      document[:d] = data[0..49] unless data.nil?
      options = {:upsert => true}
      
      if points > high_scores.daily then Score.daily_collection.update(selector, document.merge({:dt => leaderboard.daily_start}), options) end
      if points > high_scores.weekly then Score.weekly_collection.update(selector, document.merge({:dt => leaderboard.weekly_start}), options) end
      if points > high_scores.overall then Score.overall_collection.update(selector, document, options) end
      high_scores.has_new_score(points)
    end
    
    def get(leaderboard, page, records, scope)
      records = 50 if records > 50
      offset = ((page-1) * records).floor
      offset = 0 if offset < 0
    
      conditions = Score.time_condition(leaderboard, scope)
      conditions[:leaderboard_id] = leaderboard.id
      options = {:fields => {:points => 1, :username => 1, :data => 1, :_id => 0}, :sort => [:points, :desc], :skip => offset, :limit => records, :raw => true}
      find(conditions, options, Score.collection(scope))
    end
    
    def time_condition(leaderboard, scope)
      case scope
      when LeaderboardScope::Overall
        return {}
      when LeaderboardScope::Weekly
        return {:dated => leaderboard.weekly_start}
      when LeaderboardScope::Yesterday
        return {:dated => leaderboard.yesterday_start}
      else
        return {:dated => leaderboard.daily_start}
      end
    end
    
    def collection(scope)
      case scope
      when LeaderboardScope::Weekly
        return Score.weekly_collection
      when LeaderboardScope::Overall
        return Score.overall_collection
      else
        return Score.daily_collection
      end
    end
   
    def daily_collection
      Store['scores_daily'] 
    end
    def weekly_collection
      Store['scores_weekly'] 
    end
    def overall_collection
      Store['scores_overall'] 
    end
  end

end