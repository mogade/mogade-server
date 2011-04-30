class Leaderboard
  include Document
  mongo_accessor {:game_id => :gid, :name => :name, :offset => :offset}
end