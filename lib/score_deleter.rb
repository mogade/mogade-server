class ScoreDeleter
  class << self
    def find(leaderboard, scope, username)
      #this is a huge repetition of of Score.get_by_page..doh!
      #the only real difference is the limit and that we cna filter by username
      conditions = Score.time_condition(leaderboard, scope)
      conditions[:leaderboard_id] = leaderboard.id
      conditions[:username] = username  unless username.blank?
      
      prefix = Score.scope_to_prefix(scope)
      name = Score.scope_to_name(scope)
      
      cursor = Score.find(conditions, {:limit => 100, :raw => true, :sort => [prefix + '.p', leaderboard.sort], :fields => {:username => 1, prefix + '.p' => 1, prefix + '.d' => 1}})
      cursor.map{|s| {:id => s[:_id].to_s, :username => s[:username], :points => s[name][:points], :data => s[name][:data]} }
    end
    
    #deleting an overall score means adopting the user's weekly score as his new overall
    #deleting a weekly score means adopting the user's daily score as his new weekly
    #because it doesn't make sense for a user to have a weekly top score, but not have an overall top score
    def delete(leaderboard, scope, ids)
      Score.find({:leaderboard_id => leaderboard.id, :_id => {'$in' => ids}}).each do |score|
        
        if scope == LedaerboardScope::Overall && score.weekly
          if score.weekly
            score.overall.points = score.weekly.points
            score.overall.data = score.weekly.data
            score.overall.dated = score.weekly.dated
          else
            score.delete #todo handle
            redis.zrem(key, score[:userkey])
          end
        elsif scope == LeaderboardScope::Weekly
          if score.daily
            score.weekly.points = score.daily.points
            score.weekly.data = score.daily.data
            score.weekly.dated = score.daily.dated
          else
            score.weekly = nil
          end
        end

      end
    end
  end
end