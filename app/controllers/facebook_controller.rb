class FacebookController < ApplicationController
  layout 'facebook'
  
  def index
    @profile = Profile.find_by_id(params[:id])
    render '404_profile' and return if @profile.nil? || !@profile.enabled
    @leaderboards = Leaderboard.find_for_game(@profile) #dynamic trickery is afoot!
    expires_in 3.minutes, :public => true
  end
  
  def leaderboard
    @profile = Profile.find_by_id(params[:id])
    render '404_profile' and return if @profile.nil? || !@profile.enabled    
    @leaderboards = Leaderboard.find_for_game(@profile) #dynamic trickery is afoot!
    expires_in 3.minutes, :public => true
  end
end