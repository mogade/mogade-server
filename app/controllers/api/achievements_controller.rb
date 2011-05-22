class Api::AchievementsController < Api::ApiController
  before_filter :ensure_context, :only => :create
  before_filter :ensure_signed, :only => :create
  before_filter :ensure_player
  before_filter :ensure_achievement, :only => :create
  
  def index
    records = params_to_i(:records, 10)
    scope = params_to_i(:scope, LeaderboardScope::Daily)
    
    player = load_player
    if player.nil?
      payload = Score.get_by_page(@leaderboard, params_to_i(:page, 1), records, scope)
    else
      payload = Score.get_by_player(@leaderboard, player, records, scope)
    end
    render_payload(payload, params, 300)
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