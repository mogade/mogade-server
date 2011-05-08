class Api::RanksController < Api::ApiController
  before_filter :ensure_player
  before_filter :ensure_leaderboard 
  
  def index
    payload = Rank.get(@leaderboard, @player.unique)
    render_payload(payload, params, 300)
  end

end