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
  
  def update
    return unless load_game_as_owner
    return unless ensure_asset
    @asset.update(params[:name],  params[:type].to_i, params[:meta])
    redirect_to :action => 'index', :id => @game.id
  end
  
  def destroy
    return unless load_game_as_owner
    return unless ensure_asset
    @asset.destroy
    set_info("#{@asset.name} was successfully deleted", false)
    redirect_to :action => 'index', :id => @game.id
  end
  
  private
  def ensure_asset
    @asset = Asset.find_by_id(params[:id])
    return handle_access_denied if @asset.nil? || @asset.game_id != @game.id
    true
  end
end