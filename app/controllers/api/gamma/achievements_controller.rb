class Api::Gamma::AchievementsController < Api::Gamma::ApiController
  before_filter :ensure_context
  before_filter :ensure_signed, :only => :create
  before_filter :ensure_player, :only => :create
  before_filter :ensure_achievement, :only => :create
  
  def index
    player = load_player
    if player.nil?
      payload = Achievement.find_for_game(@game, true).each{|a| a[:id] = (a.delete(:_id)).to_s }
      render_payload(payload, params, 180, 30)
    else
      render :json => EarnedAchievement.earned_by_player(@game, player).map{|a| a.to_s}
    end
  end

  def create
    earned = EarnedAchievement.create(@achievement, @player)
    render :json => earned.nil? ? {} : {:points => @achievement.points, :id => @achievement.id.to_s, :name => @achievement.name, :description => @achievement.description}
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