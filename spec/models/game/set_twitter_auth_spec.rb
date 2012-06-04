require 'spec_helper'

describe Game, :set_twitter_auth do
  it "sets the token and secret and saves the game" do
    game = Game.create('ham zapper')
    game.set_twitter_auth(FakeToken.new('the-token', 'the-secret'))
    found = Game.find_one
    found.twitter_token.should == 'the-token'
    found.twitter_secret.should == 'the-secret'
  end


  class FakeToken
    attr_accessor :token, :secret

    def initialize(token, secret)
      @token = token
      @secret = secret
    end
  end
end