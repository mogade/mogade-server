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
  
  def ensure_logged_in
    load_developer
    redirect_to url_for :controller => 'sessions', :action => 'new' if @current_developer == nil
  end
  
  def load_developer
    return @current_developer if @current_developer != nil
    @current_developer = Developer.find_by_id(session[:dev_id]) if is_logged_in? 
  end

  def is_logged_in?
    session[:dev_id] != nil
  end

end