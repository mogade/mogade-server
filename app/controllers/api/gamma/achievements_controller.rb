class Api::Gamma::AchievementsController < Api::Gamma::ApiController
  before_filter :ensure_context
  before_filter :ensure_signed, :only => :create
  before_filter :ensure_player
  before_filter :ensure_achievement, :only => :create
  
  def index
    render :json => EarnedAchievement.earned_by_player(@game, @player).map{|a| a.to_s}
  end

  def create
    earned = EarnedAchievement.create(@achievement, @player)
    render :json => earned.nil? ? {} : {:points => @achievement.points, :id => @achievement.id.to_s}
  end
  
  private
  def ensure_achievement
    aid = Id.from_string(params[:aid])
    return error('missing or invalid aid (achievement id) parameter')  if aid.nil?
    @achievement = Achievement.find_by_id(aid)
    return error("id doesn't belong to an achievement") if @achievement.nil?
    return error('achievement does not belong to this game')  if @achievement.game_id != @game.id
  end
end