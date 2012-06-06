class Manage::TweetsController < Manage::ManageController
  before_filter :ensure_logged_in

  def index
    return unless load_game_as_owner
    @twitter = Twitter.find_for_game(@game)
    unless @twitter.nil?
      @leaderboards = Leaderboard.find_for_game(@game)
    end
  end

  def access
    return unless load_game_as_owner
    callback = "http://#{request.host}:#{request.port}/manage/tweets/callback?id=#{@game.id}"
    consumer = OAuth::Consumer.new(Settings.twitter['key'], Settings.twitter['secret'], :site => "https://api.twitter.com")
    request_token = consumer.get_request_token(:oauth_callback => callback)
    session[:rt] = request_token
    redirect_to request_token.authorize_url(:oauth_callback => callback)
  end

  def callback
    return unless load_game_as_owner
    begin
      token = session.delete(:rt).get_access_token
      Twitter.create(@game, token.token, token.secret)
    rescue
    end
    redirect_to :action => :index, :id => @game.id
  end

  def update
    return unless load_game_as_owner
    return unless ensure_twitter
    @twitter.update(params[:message], Id.from_string(params[:leaderboard_id]))
    set_info("Twitter settings have been updated", false)
    redirect_to :action => 'index', :id => @game.id
  end

  def destroy
    return unless load_game_as_owner
    Twitter.disable(@game)
    render :action => :index
  end

  private
  def ensure_twitter
    id = params[:id]
    return handle_access_denied unless Id.valid? id

    @twitter = Twitter.find_by_id(Id.from_string(id))
    return handle_access_denied if @twitter.nil? || @twitter.game_id != @game.id
    true
  end
end