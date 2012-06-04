class Manage::TwitterController < Manage::ManageController
  before_filter :ensure_logged_in

  def index
    return unless load_game_as_owner
  end

  def access
    return unless load_game_as_owner
    callback = "http://#{request.host}:#{request.port}/manage/twitter/callback?id=#{@game.id}"
    consumer = OAuth::Consumer.new(Settings.twitter['key'], Settings.twitter['secret'], :site => "https://api.twitter.com")
    request_token = consumer.get_request_token(:oauth_callback => callback)
    session[:rt] = request_token
    redirect_to request_token.authorize_url(:oauth_callback => callback)
  end

  def callback
    return unless load_game_as_owner
    token = session.delete(:rt).get_access_token
    @game.set_twitter_auth(token)
    render :action => :index
  end
end