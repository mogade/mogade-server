class Manage::LeaderboardsController < Manage::ManageController
  before_filter :ensure_logged_in

  def index
    return unless load_game_as_owner
    @leaderboards = Leaderboard.find_for_game(@game)
  end

  def create
    return unless load_game_as_owner
    leaderboard = Leaderboard.create(params[:name], params[:offset].to_i, params[:type].to_i, @game)
    leaderboard.save! if leaderboard.valid?
    redirect_to :action => 'index', :id => @game.id
  end
  
  def update
    return unless load_game_as_owner
    return unless ensure_leaderboard
    @leaderboard.update(params[:name], params[:offset].to_i, params[:type].to_i)
    redirect_to :action => 'index', :id => @game.id
  end
  
  def destroy
    return unless load_game_as_owner
    return unless ensure_leaderboard
    @leaderboard.destroy
    set_info("#{@leaderboard.name} was successfully deleted", false)
    redirect_to :action => 'index', :id => @game.id
  end
  
  def scores
    return unless load_game_as_owner
    @leaderboards = Leaderboard.find_for_game(@game)
  end

  private
  def ensure_leaderboard
    @leaderboard = Leaderboard.find_by_id(params[:id])
    return handle_access_denied if @leaderboard.nil? || @leaderboard.game_id != @game.id
    true
  end
end