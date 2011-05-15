class Manage::GamesController < Manage::ManageController
  before_filter :ensure_logged_in

  def index
    @games = Game.find_by_ids(@current_developer.game_ids).to_a
  end
 
  def create
    game = Game.create(params[:name])
    redirect_to :action => 'index' and return unless game.valid?
    
    game.save!
    @current_developer.created_game!(game)
    redirect_to :action => 'show', :id => game.id
  end
  
  def show
    load_game_as_owner and return if @game == nil
  end
end