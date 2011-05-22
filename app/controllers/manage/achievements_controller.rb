class Manage::AchievementsController < Manage::ManageController
  before_filter :ensure_logged_in

  def index
    return unless load_game_as_owner
    @achievements = Achievement.find_for_game(@game)
  end

  def create
    return unless load_game_as_owner
    achievement = Achievement.create(params[:name], params[:description], params[:points].to_i, @game)
    achievement.save! if achievement.valid?
    redirect_to :action => 'index', :id => @game.id
  end
  
  def update
    return unless load_game_as_owner
    return unless ensure_achievement
    @achievement.update(params[:name], params[:description], params[:points].to_i)
    redirect_to :action => 'index', :id => @game.id
  end
  
  def destroy
    return unless load_game_as_owner
    return unless ensure_achievement
    @achievement.destroy
    set_info("#{@achievement.name} was successfully deleted", false)
    redirect_to :action => 'index', :id => @game.id
  end
  
  private
  def ensure_achievement
    @achievement = Achievement.find_by_id(params[:id])
    return handle_access_denied if @achievement.nil? || @achievement.game_id != @game.id
    true
  end

end