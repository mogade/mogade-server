class Api::Legacy::ApiController < ActionController::Base
  before_filter :ensure_context
  
  private
  def ensure_context
    @version = params[:v].to_i
    return error('unknown version') unless @version == 1
    @game = Game.find_by_id(params[:key])
    return error('the key is not valid') if @game.nil?
    return error('invalid signature') unless valid_signature?(params, @game.secret)
  end
  
  def ensure_leaderboard(name, sub = nil)
    value = sub.nil?? params[name] : params[name][sub]
    return error('missing leaderboard id') if value.blank?
    @leaderboard = Leaderboard.find_by_id(Id.from_string(value))
    return error('invalid leaderboard') if @leaderboard.nil? || @leaderboard.game_id != @game.id
    true
  end
  
  def ensure_achievement
    value = params[:achievement_id]
    return error('missing achievement id') if value.blank?
    @achievement = Achievement.find_by_id(Id.from_string(value))
    return error('invalid achievement') if @achievement.nil? || @achievement.game_id != @game.id
    true
  end
  
  def load_player(within = nil)
    username = within.nil? ? params[:username] : params[within][:username]
    unique = within.nil? ? params[:unique] : params[within][:unique]
    return nil if username.blank? || unique.blank?
    @player = Player.new(username, unique)
    @player.valid?
  end
  
  def ensure_player(within = nil)
    return load_player(within) ? true : error('username and unique are both required, and username must be 30 or less characters')
  end
  
  def error(message, data = nil)
    payload = {:error => message}
    payload[:info] = flatten(data) unless data.blank?
    render :status => 400, :json => payload
    false
  end
  
  def valid_signature?(params, secret)
    return false if params[:sig].blank? && params[:sig2].blank?
    if params[:sig2].blank?
      signature = params.delete :sig
      md5 = true
    else
      signature = params.delete :sig2
      md5 = false
    end
    signature == get_signature(params, secret, md5)
  end

  def get_signature(params, secret, md5)
    raw = get_signature_string(params, secret)
    md5 ? Digest::MD5.hexdigest(raw) : Digest::SHA1.hexdigest(raw)
  end

  def get_signature_string(params, secret)
    filtered = params.reject{|key, value| key == 'action' || key == 'controller'}.to_a  
    extract(filtered).sort.collect {|k,v| [k,v].join('=') }.join("&") + "&" + secret
  end

  def extract(hash)
    newHash = Hash.new
    hash.each do |k, v|
      if v.is_a?(Hash)
        newHash.merge!(extract(v))
      elsif v.is_a?(Array)
        newHash[k] = v.join('-')
      else
        newHash[k] = v
      end
    end
    newHash
  end
end