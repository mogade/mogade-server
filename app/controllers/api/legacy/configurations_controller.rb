class Api::Legacy::ConfigurationsController < Api::Legacy::ApiController
  
  def version
    render :json => {:version => @game.version || 1}
  end
  
  def get_game_configuration
    render :json => 
    {
      :version => @game.version || 1,
      :achievements => Achievement.find_for_game(@game).map{|a| {:id => a.id.to_s, :name => a.name, :desc => a.description, :points => a.points}},
      :leaderboards => Leaderboard.find_for_game(@game).map{|l| {:id => l.id.to_s, :name => l.name}}
    }
  end
  
  def get_player_configuration
    return unless ensure_player
    render :json => 
    {
      :achievements => EarnedAchievement.earned_by_player(@game, @player).map{|a| a.to_s},
      :leaderboards => HighScores.find_for_player(@game, @player).map{|h| {:id => h.leaderboard_id.to_s, :points => h.overall_points}}
    }
  end
end