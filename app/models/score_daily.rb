# The Score (and ScoreData) class is the main places to get scores/leaderboards whatever
# This class is used specifically to enable grabbing yesterday's scores/leaderboards/whatever
# Not crazy about duplicate data in this collection, but it's the bes
class ScoreDaily
  include MongoLight::Document
  mongo_accessor({:leaderboard_id => :lid, :unique => :u, :username => :un, :data => :d, :stamp => :s, :points => :points, :dated => :dt})

  class << self
    def save(leaderboard, player, points, data = nil)
      data = data[0..49] unless data.nil? || data.length < 50
      selector = {:leaderboard_id => leaderboard.id, :unique => player.unique, :stamp => leaderboard.daily_stamp}
      update(selector, selector.merge({:username => player.username, :data => data, :dated => Time.now.utc, :points => points}), {:upsert => true})
    end
    
    def get_by_stamp_and_page(leaderboard, stamp, records, offset)
      options = {:sort => [:points, leaderboard.sort], :fields => {:username => 1, :data => 1, :dated => 1, :points => 1, :_id => -1}, :skip => offset, :limit => records, :raw => true}
      find({:leaderboard_id => leaderboard.id, :stamp => stamp}, options)
    end
  end
end