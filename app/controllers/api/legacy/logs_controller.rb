class Api::Legacy::LogsController < Api::Legacy::ApiController
  def log_start
    return error('missing unique') if params[:unique].blank?
    Stat.hit(@game, params[:unique])
    render :nothing => true    
  end
end