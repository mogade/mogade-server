class Score
  include Document
  mongo_accessor {:leaderboard_id => :lid, :user_key => :uk, :user_name => :un,
                  :score => :s, :data => :d, :dated => :dt }
end