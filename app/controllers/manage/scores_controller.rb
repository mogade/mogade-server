class Manage::ScoresController < Manage::ManageController
  before_filter :ensure_logged_in

  def index
    return unless load_game_as_owner
    @leaderboards = Leaderboard.find_for_game(@game)
  end
  
  def count
    return unless load_game_as_owner
    return unless ensure_leaderboard
    render :json => {:count => ScoreDeleter.count(@leaderboard, params[:scope].to_i, params[:field], params[:operator].to_i, params[:value])}
  end
  
  def destroy
    return unless load_game_as_owner
    return unless ensure_leaderboard
    ScoreDeleter.delete(@leaderboard, params[:scope].to_i, params[:field], params[:operator].to_i, params[:value])
    set_info('scores have been deleted', false)
    redirect_to :action => 'index', :id => @game.id
  end

end