class ScoreDeleter
  class << self
    @@operator_map = {1 => '$lt', 2 => '$lte', 4 => '$gte', 5 => '$gt'}
    
    def count(leaderboard, scope, field, operator, value)
      conditions = {:leaderboard_id => leaderboard.id}.merge(conditions(field, operator, value))
      Score.count(conditions, Score.collection(scope))
    end
    
    def delete(leaderboard, scope, field, operator, value)
      conditions = {:leaderboard_id => leaderboard.id}.merge(conditions(field, operator, value))
      Score.remove(conditions, Score.collection(scope))
    end
    
    def conditions(field, operator, value)
      if field == ScoreDeleterField::UserName
        return {:username => value}
      end
      
      operator == 3 || !@@operator_map.include?(operator) ? {:points => value.to_i} : {:points => {@@operator_map[operator] => value.to_i}}
    end
  end
end