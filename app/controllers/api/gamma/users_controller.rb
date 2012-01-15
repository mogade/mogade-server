class Api::Gamma::UsersController < Api::Gamma::ApiController
  before_filter :ensure_context
  before_filter :ensure_signed
  before_filter :ensure_player
  
  def rename
    return unless ensure_params(:newname)
    error('newname must be 30 or less characters') and return unless @player.rename(@game, params[:newname])
    render :json => true
  end
end