class Leaderboard
  include Document
  mongo_accessor({:game_id => :gid, :name => :name, :offset => :offset})
  
  def daily_start
    now = Time.now.utc
    time = now.midnight + -3600 * offset
    return time > now ? time - 86400 : time
  end
  
  def weekly_start
    now = Time.now.utc
    time = now.at_beginning_of_week + -3600 * offset
    return time > now ? time - 604800 : time
  end
end