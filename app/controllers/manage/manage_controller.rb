class Manage::ManageController < ActionController::Base
  protect_from_forgery
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

end