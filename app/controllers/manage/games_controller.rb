class Manage::GamesController < Manage::ManageController
  before_filter :ensure_logged_in
  skip_before_filter :ensure_not_https, :only => [:show, :update, :destroy]
  before_filter :ensure_https, :only => [:show, :update, :destroy]

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
    return unless load_game_as_owner
  end
  
  def update
    return unless load_game_as_owner
    @game.update(params[:name])
    render :json => {:saved => true}
  end
  
  def destroy
    return unless load_game_as_owner
    @game.destroy
    set_info("#{@game.name} was successfully deleted", false)
    redirect_to :action => 'index'
  end
  
end