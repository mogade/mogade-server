class FacebookController < ApplicationController
  layout 'facebook'
  
  def index
    @profile = Profile.find_by_id(params[:id])
    render '404_profile' and return if @profile.nil? || !@profile.enabled
    
    leaderboard = Leaderboard.find_by_id(@profile.leaderboard_id)
    @scores = {}
    LeaderboardScope.all_scopes.each do |scope|
      @scores[scope] = Score.get_by_page(leaderboard, 1, 3, scope)[:scores]
    end
    #TODO expires_in 3.minutes, :public => true
  end
  
  def leaderboard
    @profile = Profile.find_by_id(params[:id])
    render '404_profile' and return if @profile.nil? || !@profile.enabled    
    @leaderboard = Leaderboard.find_for_game(@profile) #dynamic trickery is afoot!
    #TODO expires_in 3.minutes, :public => true
  end
end