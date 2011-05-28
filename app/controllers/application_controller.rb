class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :load_developer,  :ensure_not_https
  
  private
  def ensure_not_https
    redirect_to :protocol => 'http://' if request.ssl? && Rails.env == 'production'
  end
  def ensure_https
    redirect_to :protocol => 'https://' unless request.ssl? || Rails.env != 'production'
  end

  def load_developer
    return @current_developer if @current_developer != nil
    @current_developer = Developer.find_by_id(session[:dev_id]) if is_logged_in?
  end

  def is_logged_in?
    session[:dev_id] != nil
  end
end