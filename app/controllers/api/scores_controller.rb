class Api::ScoresController < Api::ApiController
  before_filter :ensure_context, :only => :create
  before_filter :ensure_signed, :only => :create
  before_filter :ensure_player, :only => :create
  before_filter :ensure_leaderboard
  before_filter :ensures_leaderboard_for_game, :only => :create
  
  def index
    page = params_to_i(:page, 1)
    records = params_to_i(:records, 10)
    scope = params_to_i(:scope, LeaderboardScope::Daily)
    scores = Score.get(@leaderboard, page, records, scope)
    
    payload = {:page => page, :scores => scores}
    render_payload(payload, params, 300)
  end

  def create
    ensure_params(:points) || return
    high_scores = Score.save(@leaderboard, @player, params[:points].to_i, params[:data])
    
    render :json => Hash[high_scores.map{|key, value| [key, value ? Rank.get(@leaderboard, @player, [key]) : 0]}]
  end
end