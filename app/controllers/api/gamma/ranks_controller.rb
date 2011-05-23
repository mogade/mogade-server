class Api::Gamma::RanksController < Api::Gamma::ApiController
  before_filter :ensure_player
  before_filter :ensure_leaderboard 
  
  def index
    payload = Rank.get(@leaderboard, @player.unique, params[:scopes])
    render_payload(payload, params, 300)
  end

end