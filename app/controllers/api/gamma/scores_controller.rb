class Api::Gamma::ScoresController < Api::Gamma::ApiController
  before_filter :ensure_context, :only => :create
  before_filter :ensure_signed, :only => :create
  before_filter :ensure_player, :only => :create
  before_filter :ensure_leaderboard
  before_filter :ensures_leaderboard_for_game, :only => :create
  
  def index
    records = params_to_i(:records, 10)
    scope = params_to_i(:scope, LeaderboardScope::Daily)
    
    player = load_player
    if player.nil?
      payload = Score.get_by_page(@leaderboard, params_to_i(:page, 1), records, scope)
    elsif records == 1
      payload = Score.load(@leaderboard, player).for_scope(scope).attributes.merge({:username => player.username})
    else
      payload = Score.get_by_player(@leaderboard, player, records, scope)
    end
    render_payload(payload, params, 180)
  end
  
  def count
    scope = params_to_i(:scope, LeaderboardScope::Daily)
    payload = Rank.count(@leaderboard, scope) #counting off of Rank is more efficient than Score
    render_payload(payload, params, 180, 30)
  end
  
  def overview
    payload = {}
    LeaderboardScope.all_scopes.each do |scope|
      payload[scope] = Score.get_by_page(@leaderboard, 1, 3, scope)[:scores]
    end
    render_payload(payload, params, 180)
  end

  def create
    return unless ensure_params(:points)
    points = params[:points].to_i
    
    high_scores = Score.save(@leaderboard, @player, points, params[:data])
    ranks =  Rank.get_for_score(@leaderboard, points)
    render :json => {:ranks => ranks, :highs => high_scores}
  end
end