class Manage::ManageController < ActionController::Base
  protect_from_forgery
  before_filter :load_developer
  layout 'manage_dual'

  
  def faq
    render :layout => 'manage_single'
  end
  
  def tos
  end
  
  private 
  def signin(developer)
    session[:dev_id] = developer.id.to_s
    redirect_to '/manage/games/'
  end
  
  def set_error(msg, now = true)
    now ? flash.now[:error] = msg : flash[:error] = msg
  end
  
  def set_info(msg, now = true)
    now ? flash.now[:info] = msg : flash[:info] = msg
  end
  
  def ensure_logged_in
    load_developer
    redirect_to url_for :controller => 'sessions', :action => 'new' if @current_developer.nil?
  end
  
  def load_developer
    return @current_developer if @current_developer != nil
    @current_developer = Developer.find_by_id(session[:dev_id]) if is_logged_in? 
  end

  def is_logged_in?
    session[:dev_id] != nil
  end

  def load_game_as_owner
    load_game
    return false if @game.nil?
    return handle_access_denied unless !@current_developer.nil? && @current_developer.owns?(@game)
    true
  end
  def load_game
    id = params.include?(:game_id) ? params[:game_id] : params[:id]
    return handle_access_denied unless Id.valid? id
  
    @game = Game.find_by_id(id)
    return handle_access_denied if @game.nil?
  end
  
  def handle_access_denied    
    @game = nil
    set_error('you do not have access to perform that action', false)
    redirect_to url_for :controller => 'games', :action => 'index'
    false
  end
end