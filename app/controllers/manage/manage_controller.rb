class Manage::ManageController < ActionController::Base
  protect_from_forgery
  layout 'manage'
  
  private 
  def signin(developer)
    session[:dev_id] = developer.id.to_s
    redirect_to '/manage/index'
  end
end