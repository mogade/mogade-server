class Api::Gamma::ErrorsController < Api::Gamma::ApiController
  before_filter :ensure_context, :only => :create
  before_filter :ensure_signed, :only => :create
  
  def create
    return unless ensure_params(:subject)
    GameError.create(@game, params[:subject], params[:details])
    render :nothing => true
  end

end