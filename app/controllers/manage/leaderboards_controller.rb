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
end