class Api::Gamma::RanksController < Api::Gamma::ApiController
  before_filter :ensure_leaderboard 
  
  def index
    scopes = params[:scopes]
    if scopes.is_a?(Array)
      scopes.map!(&:to_i)
    elsif !scopes.nil?
      scopes = scopes.to_i
    end
    player = load_player
    score = params_to_i(:score, nil)
    if !player.nil?
      payload = Rank.get_for_player(@leaderboard, player.unique, scopes)
    elsif !score.nil?
      payload = Rank.get_for_score(@leaderboard, score, scopes)
    else
      return error('need a player or a score')
    end
    
    render_payload(payload, params, 180)
  end

end