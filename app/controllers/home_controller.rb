class HomeController < ApplicationController
  layout 'public', :only => :profile
  def index
  end
  
  def profile
    @profile = Profile.find_by_id(params[:id])
    render '404_profile' if @profile.nil? || !@profile.enabled
    
    expires_in 5.minutes, :public => true
  end
end