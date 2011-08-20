class Manage::ManageController < ApplicationController
  @@profiles = YAML::load_file('./config/game_profiles.yml')
  layout 'manage_dual'
  
  def faq
    render :layout => 'manage_single'
  end
  
  def tos
  end
  
  def drivers
    render :layout => 'manage_single'
  end
  
  def api
  end
  
  def who
    @profiles = @@profiles.clone.sort_by {rand}
    @stats = load_stats
    render :layout => 'manage_single'
  end
  
  private 
  def load_stats
    stats = Rails.cache.read('managecontroller:stats')
    if Rails.env.development? || stats.nil? || (Time.now - stats.dated) > 300
      stats = MogadeStats.load
      Rails.cache.write('managecontroller:stats', stats)
    end
    return stats
  end
  
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
  
  def ensure_leaderboard
    @leaderboard = Leaderboard.find_by_id(params[:id])
    return handle_access_denied if @leaderboard.nil? || @leaderboard.game_id != @game.id
    true
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