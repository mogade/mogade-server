module ApiHelper
  def setup      
    before :each do
      Rails.cache.clear   
      @game = Factory.create(:game)
    end
  end
  
  def self.params(game, params = {})
    {'key' => game.id, 'v' => 2}.merge(params.stringify_keys!)
  end
  
  def self.signed_params(game, params = {})
    merged = ApiHelper.params(game, params)
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
      self.send verb, action
      response.status.should == 400
      json = ActiveSupport::JSON.decode(response.body)
      json['error'].should == 'the key is not valid'
    end
    it "renders an error if the version is invalid" do
      self.send verb, action, {'key' => @game.id}
      response.status.should == 400
      json = ActiveSupport::JSON.decode(response.body)
      json['error'].should == 'unknown version'
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
  
  def it_ensures_a_valid_leaderboard(verb, action)
    it "renders an error if the lid is missing" do      
      self.send verb, action, ApiHelper.signed_params(@game)
      response.status.should == 400
      json = ActiveSupport::JSON.decode(response.body)
      json['error'].should == 'missing or invalid lid (leaderboard id) parameter'
    end
    it "renders an error if the lid is invalid" do
      self.send verb, action, ApiHelper.signed_params(@game, {:lid => 'invalid'})
      response.status.should == 400
      json = ActiveSupport::JSON.decode(response.body)
      json['error'].should == 'missing or invalid lid (leaderboard id) parameter'
    end
    it "renders an error if the lid doesn't exist" do
      self.send verb, action, ApiHelper.signed_params(@game, {:lid => Id.new})
      response.status.should == 400
      json = ActiveSupport::JSON.decode(response.body)
      json['error'].should == "id doesn't belong to a leaderboard"
    end
    it "loads a valid leaderboard into the context" do
      leaderboard = Factory.create(:leaderboard)
      self.send verb, action, ApiHelper.signed_params(@game, {:lid => leaderboard.id})
      assigns[:leaderboard].should == leaderboard
    end
  end
  
  def it_ensures_a_valid_player(verb, action)
   
  end
end