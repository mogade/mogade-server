class Api::ApiController < ActionController::Base
  before_filter :ensure_context
  before_filter :ensure_signed
  
  private
  def ensure_context
    return error('the key is not valid') if !Id.valid?(params[:key])
    
    @game = Game.find_by_id(params[:key])
    return error('the key is not valid') if @app.nil?
    
    @version = params[:v].to_i
    return error('unknown version') unless @version == 2
  end
  
  def ensure_signed
    signature = params.delete(:sig)
    raw = params.reject{|key, value| key == 'action' || key == 'controller'}.sort{|a, b| a[0] <=> b[0]}.join('|') + '|' + @game.secret

    return error('invalid signature') unless Digest::SHA1.hexdigest(raw) == signature
    @signed = true
  end

  def ensure_params(*keys)
    keys.each do |key|
      unless params.include?(key)
        render_error("missing required #{key} value")
        return false
      end
    end
    true
  end
  
  def ok
    render :json => {:ok => true}
  end

  def error(message, data = nil)
    payload = {:error => message}
    payload[:data] = data unless data.nil?
    render :status => 400, :json => payload
    nil
  end
end