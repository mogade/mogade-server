class EarnedAchievement
  include Document
  mongo_accessor({:achievement_id => :aid, :unique => :u, :username => :un, :dated => :dt})
  
  class << self
    def create(achievement, player)
      earned = EarnedAchievement.new({:achievement_id => achievement.id, :dated => Time.now.utc, :unique => player.unique, :username => player.username})
      begin
        earned.save!
        earned
      rescue Mongo::OperationFailure
        return nil if $!.duplicate?
      end
    end
    def earned_by_player(game, player)
      achievements = Achievement.find({:game_id => game.id}, {:fields => {:_id => 1}, :raw => true})
      ids = achievements.map{|a| a[:_id]}
      earned = EarnedAchievement.find({:achievement_id => {'$in' => ids}, :unique => player.unique}, {:fields => {:_id => 0, :achievement_id => 1}, :raw => true})
      earned.map{|e| e[:achievement_id]}
    end
  end

end