require 'spec_helper'

describe Manage::TwitterController, :callback do
  extend ManageHelper

  before :each do
    @token = FakeToken.new
    rt = {}
    rt.stub!(:get_access_token ).and_return(@token)
    session[:rt] = rt
  end

  setup
  it_ensures_a_logged_in_user :get, :callback
  it_ensures_developer_owns_the_game :get, :callback

  it "saves the token with the game" do
    @game.should_receive(:set_twitter_auth).with(@token)
    get :callback, :id => @game.id
  end

  it "displays the index page" do
    get :callback, :id => @game.id
    response.should render_template('manage/twitter/index')
  end


  class FakeToken
    attr_accessor :token, :secret
  end
end