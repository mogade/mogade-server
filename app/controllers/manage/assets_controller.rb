class Manage::AssetsController < Manage::ManageController
  before_filter :ensure_logged_in

  def index
    return unless load_game_as_owner
    @assets = Asset.find_for_game(@game)
  end
  
  def create
    return unless load_game_as_owner
    asset = Asset.create(params[:name], params[:type].to_i, params[:meta], @game)
    if asset.valid?
      asset.save!
      #todo upload file
    end
    redirect_to :action => 'index', :id => @game.id
  end
end