class Api::Gamma::RanksController < Api::Gamma::ApiController
  before_filter :ensure_player
  before_filter :ensure_leaderboard 
  
  def index
    scopes = params[:scopes]
    if scopes.is_a?(Array)
      scopes.map!(&:to_i)
    elsif !scopes.nil?
      scopes = scopes.to_i
    end
    payload = Rank.get_for_player(@leaderboard, @player.unique, scopes)
    render_payload(payload, params, 300)
  end

end