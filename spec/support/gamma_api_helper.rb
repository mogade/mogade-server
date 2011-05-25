module GammaApiHelper
  def setup      
    before :each do
      Rails.cache.clear   
      @game = Factory.create(:game)
    end
  end
  
  def self.params(game, params = {})
    {'key' => game.id}.merge(params.stringify_keys!)
  end
  
  def self.signed_params(game, params = {})
    merged = GammaApiHelper.params(game, params)
    sign(game, merged)
  end
  
  def self.sign(game, params)
    dup = params.dup
    raw = dup.sort{|a, b| a[0] <=> b[0]}.join('|') + '|' + game.secret
    dup['sig'] = Digest::SHA1.hexdigest(raw)
    dup
  end
  
  def self.should_be_error(response, message)
    response.status.should == 400
    JSON.parse(response.body)['error'].should == message
  end
   
  def it_ensures_a_valid_context(verb, action)
    it "renders an error if the key is missing" do
      self.send verb, action, {'v' => 2}
      response.status.should == 400
      json = ActiveSupport::JSON.decode(response.body)
      json['error'].should == 'the key is not valid'
    end
    it "loads the app in the context" do
      self.send verb, action, {'key' => @game.id, 'v' => 2}
      assigns[:game].should == @game
    end
  end
  
  def it_ensures_a_signed_request(verb, action)
    it "renders an error if the signature is missing" do
      self.send verb, action, {'key' => @game.id, 'v' => 2}
      response.status.should == 400
      json = ActiveSupport::JSON.decode(response.body)
      json['error'].should == 'invalid signature'
    end
    it "renders an error if the signature is invalid" do
      self.send verb, action, {'key' => @game.id, 'v' => 2, 'sig' => 'invalid'}
      response.status.should == 400
      json = ActiveSupport::JSON.decode(response.body)
      json['error'].should == 'invalid signature'
    end
    it "flags the request as signed when valid" do
      self.send verb, action, {'v' => 2, 'key' => @game.id, 'sig' => Digest::SHA1.hexdigest("key|#{@game.id.to_s}|v|2|#{@game.secret}")}
      assigns[:signed].should == true
    end
  end
  
  def it_ensures_a_valid_leaderboard(verb, action, block = nil)
    it "renders an error if the lid is missing" do      
      params = block.nil? ? {} : block.call
      self.send verb, action, GammaApiHelper.signed_params(@game, params)
      response.status.should == 400
      json = ActiveSupport::JSON.decode(response.body)
      json['error'].should == 'missing or invalid lid (leaderboard id) parameter'
    end
    it "renders an error if the lid is invalid" do
      params = block.nil? ? {} : block.call
      self.send verb, action, GammaApiHelper.signed_params(@game, params.merge({:lid => 'invalid'}))
      response.status.should == 400
      json = ActiveSupport::JSON.decode(response.body)
      json['error'].should == 'missing or invalid lid (leaderboard id) parameter'
    end
    it "renders an error if the lid doesn't exist" do
      params = block.nil? ? {} : block.call
      self.send verb, action, GammaApiHelper.signed_params(@game, params.merge({:lid => Id.new}))
      response.status.should == 400
      json = ActiveSupport::JSON.decode(response.body)
      json['error'].should == "id doesn't belong to a leaderboard"
    end
    it "loads a valid leaderboard into the context" do
      leaderboard = Factory.create(:leaderboard)
      params = block.nil? ? {} : block.call
      self.send verb, action, GammaApiHelper.signed_params(@game, params.merge({:lid => leaderboard.id}))
      assigns[:leaderboard].should == leaderboard
    end
  end
  
  def it_ensures_leaderboard_belongs_to_game(verb, action, block = nil)
    it "renders an error if the leaderboard's game id isn't correct" do
      leaderboard = Factory.create(:leaderboard, {:game_id => Id.new})
      params = block.nil? ? {} : block.call
      self.send verb, action, GammaApiHelper.signed_params(@game, params.merge({:lid => leaderboard.id}))
      json = ActiveSupport::JSON.decode(response.body)
      json['error'].should == "leaderboard does not belong to this game"
    end
  end
  
  def it_ensures_a_valid_player(verb, action, block = nil)
    it "renders an error if the username is missing" do
      params = block.nil? ? {} : block.call
      self.send verb, action, GammaApiHelper.signed_params(@game, params)
      response.status.should == 400
      json = ActiveSupport::JSON.decode(response.body)
      json['error'].should == 'missing required username value'
    end
    it "renders an error if the username is blank" do
      params = block.nil? ? {} : block.call
      self.send verb, action, GammaApiHelper.signed_params(@game, params.merge({:username => ''}))
      response.status.should == 400
      json = ActiveSupport::JSON.decode(response.body)
      json['error'].should == 'missing required username value'
    end
    it "renders an error if the userkey is missing" do
      params = block.nil? ? {} : block.call
      self.send verb, action, GammaApiHelper.signed_params(@game, params.merge({:username => 'paul'}))
      response.status.should == 400
      json = ActiveSupport::JSON.decode(response.body)
      json['error'].should == 'missing required userkey value'
    end
    it "renders an error if the userkey is blank" do
      params = block.nil? ? {} : block.call
      self.send verb, action, GammaApiHelper.signed_params(@game, params.merge({:username => 'jessica', :userkey => ''}))
      response.status.should == 400
      json = ActiveSupport::JSON.decode(response.body)
      json['error'].should == 'missing required userkey value'
    end
    it "renders an error if the username is too long" do
      params = block.nil? ? {} : block.call
      self.send verb, action, GammaApiHelper.signed_params(@game, params.merge({:username => 'a' * 31, :userkey => 'two'}))
      response.status.should == 400
      json = ActiveSupport::JSON.decode(response.body)
      json['error'].should == 'username and userkey are both required, and username must be 30 or less characters'
    end
  end
  
  def it_ensures_a_valid_achievement(verb, action, block = nil)
    it "renders an error if the aid is missing" do      
      params = block.nil? ? {} : block.call
      self.send verb, action, GammaApiHelper.signed_params(@game, params)
      response.status.should == 400
      json = ActiveSupport::JSON.decode(response.body)
      json['error'].should == 'missing or invalid aid (achievement id) parameter'
    end
    it "renders an error if the aid is invalid" do
      params = block.nil? ? {} : block.call
      self.send verb, action, GammaApiHelper.signed_params(@game, params.merge({:aid => 'invalid'}))
      response.status.should == 400
      json = ActiveSupport::JSON.decode(response.body)
      json['error'].should == 'missing or invalid aid (achievement id) parameter'
    end
    it "renders an error if the aid doesn't exist" do
      params = block.nil? ? {} : block.call
      self.send verb, action, GammaApiHelper.signed_params(@game, params.merge({:aid => Id.new}))
      response.status.should == 400
      json = ActiveSupport::JSON.decode(response.body)
      json['error'].should == "id doesn't belong to an achievement"
    end
    it "loads a valid achievement into the context" do
      achievement = Factory.create(:achievement)
      params = block.nil? ? {} : block.call
      self.send verb, action, GammaApiHelper.signed_params(@game, params.merge({:aid => achievement.id}))
      assigns[:achievement].should == achievement
    end
  end
  
  def it_ensures_achievement_belongs_to_game(verb, action, block = nil)
    it "renders an error if the achievement's game id isn't correct" do
      achievement = Factory.create(:achievement, {:game_id => Id.new})
      params = block.nil? ? {} : block.call
      self.send verb, action, GammaApiHelper.signed_params(@game, params.merge({:aid => achievement.id}))
      json = ActiveSupport::JSON.decode(response.body)
      json['error'].should == "achievement does not belong to this game"
    end
  end
end