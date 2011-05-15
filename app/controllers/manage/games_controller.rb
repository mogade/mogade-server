class Manage::GamesController < Manage::ManageController
  before_filter :ensure_logged_in

  def index
  end
 
  def create
    game = Game.create(params.slice(:name))
    unless game.valid?
      index and render 'index' and return
    end
    game.save!
    #@current_developer.created_game(game)
    redirect_to :action => 'view', :id => game.id
  end
end