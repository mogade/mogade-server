class Api::Gamma::StatsController < Api::Gamma::ApiController
  before_filter :ensure_context, :only => :create
  before_filter :ensure_signed, :only => :create
  
  def create
    if params[:custom]
      Stat.hit_custom(@game, params[:custom].to_i)
    elsif params[:userkey]
      Stat.hit(@game, params[:userkey])
    end
    render :nothing => true
  end

end