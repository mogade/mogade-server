class Api::ScoresController < Api::ApiController
  before_filter :ensure_player
  before_filter :ensure_leaderboard
  before_filter :ensures_leaderboard_for_game
  
  def create
    ensure_params(:points) || return
    render :json => Score.save(@leaderboard, @player, params[:points].to_i, params[:data])
  end
end