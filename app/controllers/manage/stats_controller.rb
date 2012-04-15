class Manage::StatsController < Manage::ManageController
  before_filter :ensure_logged_in

  def index
    return unless load_game_as_owner
    @weekly_unique = Stat.weekly_unique(@game)
  end
  
  def data
    return unless load_game_as_owner
    if (params[:year])
      send_data Stat.load_data_for_year(@game, params[:year]), :filename => "mogade.stats.#{@game.name}.#{2000 + params[:year].to_i}.json", :type => 'application/json'
    else    
      if (params[:custom])
        render :json => Stat.load_custom_data(@game, Time.at(params[:from].to_f).utc.midnight, Time.at(params[:to].to_f).utc.midnight)
      else
        render :json => Stat.load_data(@game, Time.at(params[:from].to_f).utc.midnight, Time.at(params[:to].to_f).utc.midnight)
      end
    end
  end
  
  def custom
    return unless load_game_as_owner
  end
  
  def update
    return unless load_game_as_owner
    @game.set_stat_names(Array.new(Stat::CUSTOM_COUNT){|i| params["stat_#{i}"] || (i + 1).to_s})
    redirect_to :action => 'custom', :id => @game.id
  end
end