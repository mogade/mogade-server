#Look away now lest you turn to stone
class Api::LegacyController < ActionController::Base
  before_filter :ensure_context
  
  def yesterdays_rank
    return unless ensure_leaderboard
    return unless ensure_player
    render :json => {:rank => Rank.get(@leaderboard, @player.unique, [LeaderboardScope::Yesterday])[LeaderboardScope::Yesterday]}
  end
  
  def log_start
    return error('missing unique') if params[:unique].blank?
    Stat.hit(@game, params[:unique])
    render :nothing => true    
  end
  
  def yesterdays_leaders
    return unless ensure_leaderboard
    render :json => Score.get_by_page(@leaderboard, 1, 3, LeaderboardScope::Yesterday)
  end
  
  def save_score
    return unless ensure_leaderboard
    return unless ensure_player(:score)
    return error('missing points') if params[:score][:points].blank?

    high_scores = Score.save(@leaderboard, @player, params[:score][:points].to_i, params[:score][:data])
    ranks = Rank.get(@leaderboard, @player.unique)
    render :json => {:daily => ranks[LeaderboardScope::Daily], :weekly => ranks[LeaderboardScope::Weekly], :overall => ranks[LeaderboardScope::Overall], :top_score => high_scores[LeaderboardScope::Overall]}
  end

end