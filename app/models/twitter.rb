class Twitter
  include MongoLight::Document
  mongo_accessor({:token => :token, :secret => :secret, :game_id => :gid, :leaderboard_id => :lid,
    :daily => {:field => :d, :class => TwitterData},
    :weekly => {:field => :w, :class => TwitterData},
    :overall => {:field => :o, :class => TwitterData}})

  TotalMessages = 30
  MinimumInterval = 10
  @@scopes = [:daily, :weekly, :overall]
  @@field_lookup = {LeaderboardScope::Daily => 'd', LeaderboardScope::Weekly => 'w', LeaderboardScope::Overall => 'o'}

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
    @@scopes.each do |scope|
      next if params[scope].nil?
      data = get_data(scope)
      data.interval = params[scope][:interval].to_i
      data.interval = Twitter::MinimumInterval if data.interval > 0 && data.interval < Twitter::MinimumInterval
    end
    self.leaderboard_id = Id.from_string(params[:leaderboard_id])
    save!
  end

  def add_message(scope, message)
    return false if message_count >= Twitter::TotalMessages
    field = "#{@@field_lookup[scope]}.m"
    Twitter.update({:_id => id}, {'$push' => {field => message}}, {:upsert => true})
    true
  end

  def remove_message(scope, index)
    field = "#{@@field_lookup[scope]}.m"
    Twitter.update({:_id => id}, {'$unset' => {"#{field}.#{index}" => true}}, {:upsert => true})
    Twitter.update({:_id => id}, {'$pull' => {field => nil}}, {:upsert => true})
  end

  def update_message(scope, index, message)
    field = "#{@@field_lookup[scope]}.m"
    Twitter.update({:_id => id}, {'$set' => {"#{field}.#{index}" => message}}, {:upsert => true})
  end

  def message_count
    count = 0
    count += daily.messages.length unless daily.nil? || daily.messages.nil?
    count += weekly.messages.length unless weekly.nil? || weekly.messages.nil?
    count += overall.messages.length unless overall.nil? || overall.messages.nil?
    count
  end

  private
  def self.new_leader(leaderboard, field, scope)
    c = count({:leaderboard_id => leaderboard.id, scope => {'$exists' => true}, field  => {'$ne' => 0}})
    return if c == 0
    Store.redis.sadd("twitter:#{scope}", leaderboard.id)
  end

  def get_data(scope)
    data = self.send(scope)
    if data.nil?
      data = TwitterData.new
      self.send("#{scope}=", data)
    end
    data
  end
end