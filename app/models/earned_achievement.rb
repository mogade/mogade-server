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
  end

end