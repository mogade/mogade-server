class Api::ScoresController < Api::ApiController
  #before_filter :ensure_player
  before_filter :ensure_leaderboard
  
  def create
    ensure_params(:points) || return
    #Score.save(@leaderboard, @player, params[:points], params[:data])
    
    render :nothing => true
  end
end