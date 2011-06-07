class Manage::ProfilesController < Manage::ManageController
  before_filter :ensure_logged_in
  
  def index
    return unless load_game_as_owner
    @profile = Profile.load_for_game(@game)
  end
  
  def create
    return unless load_game_as_owner
    profile = Profile.create_or_update(params[:name], params[:game_url], params[:developer], params[:developer_url], params[:description], params[:enabled].to_i, @game)
    if profile.valid?
      profile.save!
      set_info('the profile was successfully saved', false)
    end
    redirect_to :action => 'index', :id => @game.id
  end
  
  def images
    return unless load_game_as_owner
    @profile = Profile.load_for_game(@game)
  end
  
  def upload
    return unless load_game_as_owner
    profile = Profile.load_for_game(@game)
    index = params[:index].to_i
    name = profile.save_image(params[:qqfile], request.body, index)
    render :json => {:name => name, :index => index}
  end
  
  def destroy
    return unless load_game_as_owner
    profile = Profile.load_for_game(@game)
    index = params[:id].to_i
    profile.remove_image(index)
    render :json => {:index => index}
  end
end