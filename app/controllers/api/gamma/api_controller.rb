class Api::Gamma::ApiController < ActionController::Base

  private
  def ensure_context
    return error('the key is not valid') if !Id.valid?(params[:key])
    
    @game = Game.find_by_id(params[:key])
    return error('the key is not valid') if @game.nil?
  end
  
  def ensure_signed
    signature = params.delete(:sig)
    raw = params.reject{|key, value| key == 'action' || key == 'controller'}.sort{|a, b| a[0] <=> b[0]}.join('|') + '|' + @game.secret

    return error('invalid signature') unless Digest::SHA1.hexdigest(raw) == signature
    @signed = true
  end
  
  def ensure_leaderboard
    lid = Id.from_string(params[:lid])
    return error('missing or invalid lid (leaderboard id) parameter') if lid.nil?
    
    @leaderboard = Leaderboard.find_by_id(lid)
    error("id doesn't belong to a leaderboard") if @leaderboard.nil?
  end
  
  def ensures_leaderboard_for_game
    error('leaderboard does not belong to this game') if @leaderboard.game_id != @game.id
  end
  
  def ensure_player
    return unless ensure_params(:username, :userkey)
    @player = load_player
    
    unless @player.valid?
      error('username and userkey are both required, and username must be 30 or less characters') 
    end
  end
  
  def load_player
    return nil if params[:username].blank? || params[:userkey].blank?
    Player.new(params[:username], params[:userkey])
  end

  def ensure_params(*keys)
    valid = true
    keys.each do |key|
      unless params.include?(key) && !params[key].blank?
        error("missing required #{key} value")
        valid = false
        return
      end
    end
    valid
  end
  
  def ok
    render :json => {:ok => true}
  end

  def error(message, data = nil)
    payload = {:error => message}
    payload[:data] = data unless data.nil?
    render :status => 400, :json => payload
    true
  end
  
  def render_payload(payload, params, cache_duration = 0, api_cache_duration = 0)
    payload = ActiveSupport::JSON.encode(payload)
    if params.include?(:callback)
      expires_in cache_duration.seconds, :public => true unless cache_duration == 0
      render :text => "#{params[:callback]}(#{payload});", :content_type => 'application/javascript'
    else
      expires_in api_cache_duration.seconds, :public => true unless api_cache_duration == 0
      render :json => payload
    end
  end
  
  def params_to_i(name, default)
    #the way this treats 0 as NaN is going to come back and get us
    value = params[name].to_i
    value == 0 ? default : value
  end
end