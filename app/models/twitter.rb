class Twitter
  include MongoLight::Document
  mongo_accessor({:token => :token, :secret => :secret, :game_id => :gid, :leaderboard_id => :lid, :daily_message => :dm, :overall_message => :om})

  def self.create(game, token, secret)
    update({:game_id => game.id}, {'$set' => {:token => token, :secret => secret}}, {:upsert => true})
  end

  def self.disable(game)
    remove({:game_id => game.id})
  end

  def self.find_for_game(game)
    find_one({:game_id => game.id})
  end

  def self.new_daily_leader(leaderboard)
    c = count({:leaderboard_id => leaderboard.id, :daily_message  => {'$ne' => nil}})
    return if c == 0
    Store.redis.sadd("twitter:daily", leaderboard.id)
  end

  def self.new_overall_leader(leaderboard)
    c = count({:leaderboard_id => leaderboard.id, :overall_message  => {'$ne' => nil}})
    return if c == 0
    Store.redis.sadd("twitter:overall", leaderboard.id)
  end

  def update(daily_message, overall_message, leaderboard_id)
    self.daily_message = daily_message.blank? ? nil : daily_message
    self.overall_message = overall_message.blank? ? nil : overall_message
    self.leaderboard_id = leaderboard_id
    save!
  end
end