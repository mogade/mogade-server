class Api::Legacy::AchievementsController < Api::Legacy::ApiController
  
  def create
    return unless ensure_player
    return unless ensure_achievement
    
    earned = EarnedAchievement.create(@achievement, @player)
    render :json => {:points => @achievement.points, :id => @achievement.id.to_s}
  end

end