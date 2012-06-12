class HomeController < ApplicationController
  @@profiles = YAML::load_file('./config/game_profiles.yml')

  def index;  end

  def who
    @profiles = @@profiles.clone.sort_by {rand}
    @stats = load_stats
    render :layout => 'manage_single'
  end

  def breakit
    raise StandardError.new("your error is #{params[:id].to_i}")
  end


  def load_stats
    stats = Rails.cache.read('managecontroller:stats')
    if Rails.env.development? || stats.nil? || (Time.now - stats.dated) > 300
      stats = MogadeStats.load
      Rails.cache.write('managecontroller:stats', stats)
    end
    return stats
  end

end