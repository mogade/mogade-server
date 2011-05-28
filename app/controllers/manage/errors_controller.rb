class Manage::ErrorsController < Manage::ManageController
  before_filter :ensure_logged_in

  def index
    return unless load_game_as_owner
    @count = GameError.count({:game_id => @game.id})
  end
  
  def list
    return unless load_game_as_owner
    render :partial => 'manage/errors/error_row', :collection => GameError.paged(@game, params[:page].to_i), :as => :error
  end

end