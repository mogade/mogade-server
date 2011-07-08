class Manage::ScoresController < Manage::ManageController
  before_filter :ensure_logged_in

  def index
    return unless load_game_as_owner
    @leaderboards = Leaderboard.find_for_game(@game)
  end
  
  def find
    return unless load_game_as_owner
    return unless ensure_leaderboard
    render :json => ScoreDeleter.find(@leaderboard, params[:scope].to_i, params[:username])
  end
  
  def destroy
    return unless load_game_as_owner
    return unless ensure_leaderboard
    ScoreDeleter.delete(@leaderboard, params[:scope].to_i, params[:field].to_i, params[:operator].to_i, params[:value])
    set_info('scores have been deleted', false)
    redirect_to :action => 'index', :id => @game.id
  end

end