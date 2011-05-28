class Manage::ErrorsController < Manage::ManageController
  before_filter :ensure_logged_in

  def index
    return unless load_game_as_owner
    @count = GameError.count({:game_id => @game.id})
  end
  
  def list
    return unless load_game_as_owner
    render :partial => 'manage/errors/error_row', :collection => GameError.paged(@game, params[:page].to_i).to_a, :as => :error
  end

  def destroy
    return unless load_game_as_owner
    GameError.remove({:game_id => @game.id, :_id => Id.from_string(params[:id])})
    set_info("error was successfully deleted", false)
    redirect_to :action => 'index', :id => @game.id
  end
end