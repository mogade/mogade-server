class Twitter
  include MongoLight::Document
  mongo_accessor({:token => :token, :secret => :secret, :game_id => :gid, :leaderboard_id => :lid,
    :daily => {:field => :d, :class => TwitterData},
    :weekly => {:field => :w, :class => TwitterData},
    :overall => {:field => :o, :class => TwitterData}})

  MessagePerScope = 10
  MinimumInterval = 10

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
    new_leader(leaderboard, 'd.i', :daily)
  end

  def self.new_weekly_leader(leaderboard)
    new_leader(leaderboard, 'w.i',  :weekly)
  end

  def self.new_overall_leader(leaderboard)
    new_leader(leaderboard, 'o.i', :overall)
  end

  def update(params)
    [:daily, :weekly, :overall].each do |scope|
      next if params[scope].nil?

      data = self.send(scope)
      if data.nil?
        data = TwitterData.new
        self.send("#{scope}=", data)
      end
      data.interval = params[scope][:interval].to_i
      data.interval = Twitter::MinimumInterval if data.interval > 0 && data.interval < Twitter::MinimumInterval
    end
    self.leaderboard_id = Id.from_string(params[:leaderboard_id])
    save!
  end

  private
  def self.new_leader(leaderboard, field, scope)
    c = count({:leaderboard_id => leaderboard.id, scope => {'$exists' => true}, field  => {'$ne' => 0}})
    return if c == 0
    Store.redis.sadd("twitter:#{scope}", leaderboard.id)
  end
end