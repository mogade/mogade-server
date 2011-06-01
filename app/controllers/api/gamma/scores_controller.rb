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
    else
      payload = Score.get_by_player(@leaderboard, player, records, scope)
    end
    render_payload(payload, params, 300)
  end

  def create
    return unless ensure_params(:points)
    high_scores = Score.save(@leaderboard, @player, params[:points].to_i, params[:data])
    ranks = {}
    high_scores.each{|key, value| ranks.merge!(value ? Rank.get_for_player(@leaderboard, @player.unique, [key]) : {key => 0})}
    render :json => ranks
  end
end