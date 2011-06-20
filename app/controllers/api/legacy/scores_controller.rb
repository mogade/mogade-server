class Api::Legacy::ScoresController < Api::Legacy::ApiController
  
  def get_scores
    return unless ensure_leaderboard(:leaderboard, :id)

    page = params[:leaderboard][:page].to_i || 1
    records = params[:leaderboard][:records].to_i  || 10
    scope = params[:leaderboard][:scope].to_i  || 1
    
    scores = Score.get_by_page(@leaderboard, page, records, scope)
    payload = {:page => page, :scores => scores[:scores].map{|s| s.merge({:cat => s.delete(:dated)})}}
    
    if page == 1 && load_player
      high = Score.load(@leaderboard, @player).for_scope(scope)
      payload[:user] = high.points == 0 ? nil : {:username => @player.username, :points => high.points, :data => high.data, :rank => Rank.get_for_player(@leaderboard, @player.unique, scope)}
    end
    
    render :json => payload.merge({:page => page.to_i})
  end
  
  def yesterdays_rank
    return unless ensure_leaderboard(:leaderboard_id)
    return unless ensure_player
    render :json => {:rank => Rank.get_for_player(@leaderboard, @player.unique, LeaderboardScope::Yesterday)}
  end
  
  def yesterdays_leaders
    return unless ensure_leaderboard(:leaderboard_id)
    render :json => Score.get_by_page(@leaderboard, 1, 3, LeaderboardScope::Yesterday)
  end
  
  def save_score
    return unless ensure_leaderboard(:leaderboard_id)
    return unless ensure_player(:score)
    return error('missing points') if params[:score][:points].blank?
    
    score = params[:score][:points].to_i
    high_scores = Score.save(@leaderboard, @player, score, params[:score][:data])
    ranks = Rank.get_for_score(@leaderboard, score)
    render :json => {:daily => ranks[LeaderboardScope::Daily], :weekly => ranks[LeaderboardScope::Weekly], :overall => ranks[LeaderboardScope::Overall], :top_score => high_scores[LeaderboardScope::Overall]}
  end
end