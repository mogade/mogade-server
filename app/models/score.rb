class Score
  include Document
  mongo_accessor({:leaderboard_id => :lid, :username => :un, :points => :p, :data => :d, :dated => :dt})

  class << self
    def save(leaderboard, player, points, data = nil)
      high_scores = player.high_scores(leaderboard)
      document = {:lid => leaderboard.id, :un => player.username[0..19], :p => points}
      document[:d] = data[0..49] unless data.nil?
      
      if points > high_scores.daily then
        high_scores.daily_id = save_or_update(Score.daily_collection, high_scores.daily_id, document.merge({:dt => leaderboard.daily_start}))
      end
      if points > high_scores.weekly
        high_scores.weekly_id = save_or_update(Score.weekly_collection, high_scores.weekly_id, document.merge({:dt => leaderboard.weekly_start}))
      end
      if points > high_scores.overall
        high_scores.overall_id = save_or_update(Score.overall_collection, high_scores.overall_id, document)
      end
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
    
    def save_or_update(collection, id, document)
      return collection.insert(document) if id.nil?
      collection.update({:_id => id}, document) 
      id
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