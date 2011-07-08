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
    
    def delete(leaderboard, scope, ids)
      conditions = {:leaderboard_id => leaderboard.id}.merge(conditions(field, operator, value, scope))
      redis = Store.redis
      key = Rank.get_key(leaderboard, scope)
      Score.find(conditions, {:fields => {:userkey => 1, :_id => -1}, :raw => true}).each do |score|
        redis.zrem(key, score[:userkey])
      end
      Score.update(conditions, {'$set' => { Score.scope_to_name(scope) => nil}}, {:multi => true})
    end
    
    def conditions(field, operator, value, scope)
      return {:username => value} if field == ScoreDeleterField::UserName
      prefix = Score.prefixes[scope]
      operator == 3 || !@@operator_map.include?(operator) ? {prefix + '.p' => value.to_i} : {prefix + '.p' => {@@operator_map[operator] => value.to_i}}
    end
  end
end