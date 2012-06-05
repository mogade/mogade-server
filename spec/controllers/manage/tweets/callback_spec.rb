require 'spec_helper'

describe Manage::TweetsController, :callback do
  extend ManageHelper

  before :each do
    @token = FakeToken.new('tk', 'se')
    rt = {}
    rt.stub!(:get_access_token ).and_return(@token)
    session[:rt] = rt
  end

  setup
  it_ensures_a_logged_in_user :get, :callback
  it_ensures_developer_owns_the_game :get, :callback

  it "saves the token with the game" do
    Twitter.should_receive(:create).with(@game, 'tk', 'se')
    get :callback, :id => @game.id
  end

  it "displays the index page" do
    get :callback, :id => @game.id
    response.should redirect_to("http://test.host/manage/tweets?id=#{@game.id}")
  end

  class FakeToken
    attr_accessor :token, :secret

    def initialize(token, secret)
      @token = token
      @secret = secret
    end
  end
end