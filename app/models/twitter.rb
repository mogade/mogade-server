class Twitter
  include MongoLight::Document
  mongo_accessor({:token => :token, :secret => :secret, :game_id => :gid, :leaderboard_id => :lid, :message => :message})

  def self.create(game, token, secret)
    update({:game_id => game.id}, {'$set' => {:token => token, :secret => secret}}, {:upsert => true})
  end

  def self.disable(game)
    remove({:game_id => game.id})
  end

  def self.find_for_game(game)
    find_one({:game_id => game.id})
  end

  def update(message, leaderboard_id)
    self.message = message
    self.leaderboard_id = leaderboard_id
    save!
  end
end