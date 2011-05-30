# The Score (and ScoreData) class is the main places to get scores/leaderboards whatever
# This class is used specifically to enable grabbing yesterday's scores/leaderboards/whatever
# Not crazy about duplicate data in this collection, but it's the bes
class ScoreDaily
  include Document
  mongo_accessor({:leaderboard_id => :lid, :unique => :u, :username => :un, :data => :d, :stamp => :s, :points => :points, :dated => :dt})

  class << self
    def save(leaderboard, player, points, data = nil)
      data = data[0..49] unless data.nil? || data.length < 50
      selector = {:leaderboard_id => leaderboard.id, :unique => player.unique, :stamp => leaderboard.daily_stamp}
      update(selector, selector.merge({:username => player.username, :data => data, :dated => Time.now.utc, :points => points}), {:upsert => true})
    end
  end
end