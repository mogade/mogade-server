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
    render :json => Score.save(@leaderboard, @player, params[:points].to_i, params[:data])
  end
end