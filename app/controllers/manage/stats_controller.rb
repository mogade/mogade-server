class Manage::StatsController < Manage::ManageController
  before_filter :ensure_logged_in

  def index
    return unless load_game_as_owner
  end
  
  def data
    return unless load_game_as_owner
    if (params[:year])
      send_data Stat.load_data_for_year(@game, params[:year]), :filename => "mogade.stats.#{@game.name}.#{2000 + params[:year].to_i}.json", :type => 'application/json'
    else    
      render :json => Stat.load_data(@game, Time.at(params[:from].to_f).utc.midnight, Time.at(params[:to].to_f).utc.midnight)
    end
  end
end