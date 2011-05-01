class Score
  include Document
  mongo_accessor({:leaderboard_id => :lid, :unique => :u, :username => :un,
                  :points => :p, :data => :d, :dated => :dt })

  class << self
    def save(leaderboard, player, points, data)
      #todo
    end
  end
end