class Manage::TwitterController < Manage::ManageController
  before_filter :ensure_logged_in

  def index
    return unless load_game_as_owner
  end

  def access
    return unless load_game_as_owner
    consumer = OAuth::Consumer.new("zJlTKtwjELfAJlSSvKDtYg","P3uq7Yih2YeYWGG6sTpiPj7Kd65hHSoZtGSnVdDURsg", :site => "https://api.twitter.com")
    request_token = consumer.get_request_token(:oauth_callback => "http://#{request.host}:#{request.port}/manage/twitter/callback")
    session[:rt] = request_token
    redirect_to request_token.authorize_url(:oauth_callback => "http://#{request.host}:#{request.port}/manage/twitter/callback?id=#{game.id}")
  end

  def callback
    return unless load_game_as_owner
    token = session.delete(:rt).get_access_token
    @game.set_twitter_auth(token)
    render :action => :index
  end
end