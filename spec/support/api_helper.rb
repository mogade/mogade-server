module ApiHelper
  def setup      
    before :each do
      Rails.cache.clear      
      @game = Game.create!({:secret => "it's over 9000"})
    end
  end
  
  def self.params(app, params = {})
    {'key' => app.id, 'v' => 2}.merge(params.stringify_keys!)
  end
  
  def self.signed_params(app, params = {})
    merged = ApiHelper.params(app, params)
    sign(app, merged)
  end
  
  def self.sign(app, params)
    dup = params.dup
    raw = dup.sort{|a, b| a[0] <=> b[0]}.join('|') + '|' + app.secret
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
      assigns[:game].id.should == @game.id
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
end